// Flutter Web Loader (CDN version)
if (!window._flutter) {
  window._flutter = {};
}

_flutter.loader = {
  loadEntrypoint: function (options) {
    var script = document.createElement('script');
    script.src = "https://storage.googleapis.com/flutter_infra_release/releases/stable/web/flutter.js";
    script.defer = true;
    script.onload = function () {
      if (window._flutter) {
        window._flutter.loader.loadEntrypoint(options);
      }
    };
    document.body.appendChild(script);
  }
};

