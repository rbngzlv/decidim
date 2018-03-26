$(() => {
  if ($(".edit_assembly_member, .new_assembly_member").length > 0) {
    const $assemblyMemberPosition = $("#assembly_member_position");
    const $assemblyMemberPositionOther = $("#assembly_member_position_other");

    const togglePositionOther = (event) => {
      const value = $(event.target).val();

      $assemblyMemberPositionOther.attr("disabled", value !== "other");
      $assemblyMemberPositionOther.parents(".row").toggleClass("hide", value !== "other")
    };

    $assemblyMemberPosition.
      on("change", togglePositionOther).
      trigger("change");

    $(document).on("open.zf.reveal", "#data_picker-modal", function () {
      let xhr = null;

      $("#data_picker-autocomplete").autoComplete({
        minChars: 2,
        source: function(term, response) {
          try {
            xhr.abort();
          } catch (exception) { xhr = null}

          xhr = $.getJSON(
            $("#data_picker-autocomplete").data("url"),
            { term: term },
            function(data) { response(data); }
          );
        },
        renderItem: function (item, search) {
          let sanitizedSearch = search.replace(/[-/\\^$*+?.()|[\]{}]/g, "\\$&");
          let re = new RegExp(`(${sanitizedSearch.split(" ").join("|")})`, "gi");
          let modelId = item[0];
          let name = item[1];
          let nickname = item[2];
          let val = `${name} (@${nickname})`;
          return `<div class="autocomplete-suggestion" data-model-id="${modelId}" data-val="${val}">${val.replace(re, "<b>$1</b>")}</div>`;
        },
        onSelect: function(event, term, item) {
          let choose = $("#user-picker-choose");
          let modelId = item.data("modelId");
          let val = `${item.data("val")}`;
          choose.data("picker-value", modelId);
          choose.data("picker-text", val);
          choose.data("picker-choose", "")
        }
      })
    });
  }
});
