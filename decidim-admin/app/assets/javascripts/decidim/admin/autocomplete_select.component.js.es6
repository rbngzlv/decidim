// = require selectize

((exports) => {

  class AutocompleteSelectComponent {

    /**
     * Creates an autocomplete select using selectize.
     *
     * @param {String} selectSelector The select selector to be selectized.
     * @param {Object} options An object containing the same options as selectize.
     *
     * @returns {void} Nothing.
     */
    constructor(selectSelector, options) {
      let xhr = null;

      let defaultOptions = {
        valueField: "value",
        labelField: "label",
        searchField: ["label", "caption"],
        closeAfterSelect: true,
        hideSelected: true,
        create: false,
        options: [],
        items: [],
        plaecholder: "Pick a user",
        render: {
          item: function(item, escape) {
            let outputHTML = escape(item.label)

            if (item.option) {
              outputHTML += ` (${escape(item.nickname)})`
            }

            return `<div>${outputHTML}</div>`
          },
          option: function(item, escape) {
            let outputHTML = `<span class="selecize__label">${escape(item.label)}</span>`

            if (item.option) {
              outputHTML += `<span class="selecize__caption">${escape(item.nickname)}</span>`
            }

            return `<div>${outputHTML}</div>`
          }
        },
        load: (query, callback) => {
          if (!query.length) {
            return callback()
          }

          try {
            xhr.abort();
          } catch (exception) { xhr = null }

          xhr = $.ajax({
            url: $(selectSelector).data("search-url"),
            type: "GET",
            dataType: "json",
            data: {
              term: query
            },
            error: function() {
              callback();
            },
            success: function(data) {
              callback(data);
            }
          });

          return true;
        }
      }

      if ($(selectSelector).length > 0) {
        const $select = $(selectSelector);

        if ($select.data("options")) {
          defaultOptions.options = $select.data("options");
        }

        if ($select.data("selected")) {
          defaultOptions.items = $select.data("selected");
        }

        $select.selectize($.extend(defaultOptions, options));
      }
    }
  }

  exports.DecidimAdmin = exports.DecidimAdmin || {};
  exports.DecidimAdmin.AutocompleteSelectComponent = AutocompleteSelectComponent;
  exports.DecidimAdmin.createAutocompleteSelect = (selectSelector, options) => {
    return new AutocompleteSelectComponent(selectSelector, options);
  };
})(window);
