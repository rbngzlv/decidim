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
  }
});
