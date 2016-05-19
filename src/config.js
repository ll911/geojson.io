module.exports = function(hostname) {
    // Settings for geojson.io
    L.mapbox.accessToken = 'pk.eyJ1IjoibWFwYm94IiwiYSI6IlpIdEpjOHcifQ.Cldl4wq_T5KOgxhLvbjE-w';
    if (hostname === 'geojson.io') {
        L.mapbox.config.FORCE_HTTPS = true;
        return {
            client_id: '248cce2a588d6f60f160',
            gatekeeper_url: 'https://gatekeeper.pathfinder.gov.bc.ca'
        };
    // Customize these settings for your own development/deployment
    // version of geojson.io.
    } else {
        L.mapbox.config.HTTP_URL = 'http://a.tiles.mapbox.com/v4';
        L.mapbox.config.HTTPS_URL = 'https://a.tiles.mapbox.com/v4';
        L.mapbox.config.FORCE_HTTPS = true;
        L.mapbox.config.REQUIRE_ACCESS_TOKEN = true;
        return {
            GithubAPI: null,
            client_id: '248cce2a588d6f60f160',
            gatekeeper_url: 'https://gatekeeper.pathfinder.gov.bc.ca'
        };
    }
};
