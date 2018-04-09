// = require ./field_dependent_inputs.component

((exports) => {
  const { createFieldDependentInputs } = exports.DecidimAdmin;

  const $assemblyMemberPosition = $("#assembly_member_position");

  createFieldDependentInputs({
    controllerField: $assemblyMemberPosition,
    wrapperSelector: ".position-fields",
    dependentFieldsSelector: ".position-fields--position-other",
    dependentInputSelector: "input",
    enablingValues: ["other"]
  });

  const $assemblyMemberType = $("#assembly_member_existing_user");

  createFieldDependentInputs({
    controllerField: $assemblyMemberType,
    wrapperSelector: ".user-fields",
    dependentFieldsSelector: ".user-fields--full-name",
    dependentInputSelector: "input",
    enablingValues: ["false"]
  });

  createFieldDependentInputs({
    controllerField: $assemblyMemberType,
    wrapperSelector: ".user-fields",
    dependentFieldsSelector: ".user-fields--user-picker",
    dependentInputSelector: "input",
    enablingValues: ["true"]
  });

  if ($(".edit_assembly_member, .new_assembly_member").length > 0) {
    let xhr = null;

    $(".user-autocomplete")
      .autoComplete({
        minChars: 2,
        source: function(term, response) {
          try {
            xhr.abort();
          } catch (exception) { xhr = null }

          xhr = $.getJSON(
            $(".user-autocomplete").data("url"),
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
          let modelId = item.data("modelId");
          let val = `${item.data("val")}`;
          $("#assembly_member_user_id").val(modelId);
          $(".user-autocomplete").val(val);
        }
      })
      .on('keyup', () => {
        let value = $(this).val();
        if (value === "") {

        }
      })
  }
})(window);
