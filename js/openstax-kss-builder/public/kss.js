(function() {

  // Converts a NodeList to an Array
  function toArray(obj) {
    var array = [];
    // iterate backwards ensuring that length is an UInt32
    for (var i = obj.length >>> 0; i--;) {
      array[i] = obj[i];
    }
    return array;
  }

  var markupNodes = toArray(document.querySelectorAll('.kss-markup')).forEach(function(markupEl) {

    // The <pre> tag contains text representing 2 <section> elements;
    // 1 for the Raw HTML and 1 for the cooked HTML.
    //
    // 1. Pull them into a div (so the extra <html> and <body> tags are removed)
    // 2. Insert them back into the DOM with a little heading describing what they do
    // 3. run prettify to make the markup look nice

    var preEl = markupEl.querySelector('pre');
    var containerToParseMarkup = document.createElement('div');
    containerToParseMarkup.innerHTML=preEl.innerText;

    // Some conversions apparently don't have a Raw HTML and a Cooked HTML.
    // probably because they are Page or Metadata snippets and are inline in the HTML
    // so skip them.
    if (containerToParseMarkup.querySelector('.-kss-autogen-guide-markup')) {

      toArray(containerToParseMarkup.querySelectorAll('.-kss-autogen-guide-markup')).forEach(function(sectionEl) {
        var theMarkup = sectionEl.innerHTML;
        var preNode = document.createElement('pre');
        preNode.classList.add('prettyprint');
        preNode.classList.add('linenums');
        preNode.classList.add('lang-html');
        theMarkup = theMarkup.trim();

        preNode.innerText = theMarkup;
        sectionEl.innerHTML = '';
        sectionEl.appendChild(preNode);
      })
      markupEl.replaceChild(containerToParseMarkup, preEl);
    }


  });

  prettyPrint();

  // Hides all the formats except for the selected one
  function showTheFormatAndHideOthers(theFormat) {

    // Special-case when user selected to see all formats
    if (theFormat === '-all') {
      toArray(document.querySelectorAll('.kss-markup .-kss-autogen-guide-markup'))
      .forEach(function(sectionEl) {
        sectionEl.classList.remove('-toggle-hidden');
      });

    } else if (theFormat === '-none') {
      toArray(document.querySelectorAll('.kss-markup .-kss-autogen-guide-markup'))
      .forEach(function(sectionEl) {
        sectionEl.classList.add('-toggle-hidden');
      });

    } else {
      toArray(document.querySelectorAll('.kss-markup .-kss-autogen-guide-markup'))
      .forEach(function(sectionEl) {
        sectionEl.classList.add('-toggle-hidden');
      });
      toArray(document.querySelectorAll('.kss-markup .-kss-autogen-guide-markup[data-kss-format="' + theFormat + '"]'))
      .forEach(function(sectionEl) {
        sectionEl.classList.remove('-toggle-hidden');
      });
    }
  }

  document.getElementById('choose-which-format-to-look-at')
  .addEventListener('change', function(evt) {
    var whatFormatToShow = evt.target.value;
    showTheFormatAndHideOthers(whatFormatToShow);
  });

  // Show the default format:
  var whatFormatToShow = document.getElementById('choose-which-format-to-look-at').value;
  showTheFormatAndHideOthers(whatFormatToShow);


  // var KssStateGenerator;
  //
  // KssStateGenerator = (function() {
  //   var pseudo_selectors;
  //
  //   pseudo_selectors = ['hover', 'enabled', 'disabled', 'active', 'visited', 'focus', 'target', 'checked', 'empty', 'first-of-type', 'last-of-type', 'first-child', 'last-child'];
  //
  //   function KssStateGenerator() {
  //     var idx, idxs, pseudos, replaceRule, rule, stylesheet, _i, _len, _len2, _ref, _ref2;
  //     pseudos = new RegExp("(\\:" + (pseudo_selectors.join('|\\:')) + ")", "g");
  //     try {
  //       _ref = document.styleSheets;
  //       for (_i = 0, _len = _ref.length; _i < _len; _i++) {
  //         stylesheet = _ref[_i];
  //         if (stylesheet.href && stylesheet.href.indexOf(document.domain) >= 0) {
  //           idxs = [];
  //           _ref2 = stylesheet.cssRules;
  //           for (idx = 0, _len2 = _ref2.length; idx < _len2; idx++) {
  //             rule = _ref2[idx];
  //             if ((rule.type === CSSRule.STYLE_RULE) && pseudos.test(rule.selectorText)) {
  //               replaceRule = function(matched, stuff) {
  //                 return matched.replace(/\:/g, '.pseudo-class-');
  //               };
  //               this.insertRule(rule.cssText.replace(pseudos, replaceRule));
  //             }
  //             pseudos.lastIndex = 0;
  //           }
  //         }
  //       }
  //     } catch (_error) {}
  //   }
  //
  //   KssStateGenerator.prototype.insertRule = function(rule) {
  //     var headEl, styleEl;
  //     headEl = document.getElementsByTagName('head')[0];
  //     styleEl = document.createElement('style');
  //     styleEl.type = 'text/css';
  //     if (styleEl.styleSheet) {
  //       styleEl.styleSheet.cssText = rule;
  //     } else {
  //       styleEl.appendChild(document.createTextNode(rule));
  //     }
  //     return headEl.appendChild(styleEl);
  //   };
  //
  //   return KssStateGenerator;
  //
  // })();
  //
  // new KssStateGenerator;
  //
}).call(this);
