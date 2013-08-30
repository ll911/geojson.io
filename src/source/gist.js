var fs = require('fs'),
    tmpl = fs.readFileSync('data/share.html', 'utf8');

module.exports.save = save;
module.exports.saveBlocks = saveBlocks;
module.exports.load = load;

function saveBlocks(content, callback) {
    var endpoint = 'https://api.github.com/gists';

    d3.json(endpoint)
        .on('load', function(data) {
            callback(null, data);
        })
        .on('error', function(err) {
            callback('Gist API limit exceeded; saving to GitHub temporarily disabled: ' + err);
        })
        .send('POST', JSON.stringify({
            description: 'via:geojson.io',
            public: true,
            files: {
                'index.html': { content: tmpl },
                'map.geojson': { content: content }
            }
        }));
}

function save(context, callback) {

    var d = context.data.all();

    context.user.details(onuser);

    function onuser(err, user) {
        var endpoint,
            method = 'POST';

        if (!err && user && user.login && d.github && d.github.user && d.github.user.login == user.login) {
            endpoint = 'https://api.github.com/gists/' + d.github.id;
            method = 'PATCH';
        } else if (!err && d.github && d.github.id) {
            endpoint = 'https://api.github.com/gists/' + d.github.id + '/forks';
        } else {
            endpoint = 'https://api.github.com/gists';
        }

        context.user.signXHR(d3.json(endpoint))
            .on('load', function(data) {
                callback(null, data);
            })
            .on('error', function(err) {
                callback('Gist API limit exceeded; saving to GitHub temporarily disabled: ' + err);
            })
            .send(method, JSON.stringify({
                description: 'via:geojson.io',
                public: true,
                files: {
                    'map.geojson': {
                        content: JSON.stringify(d.map)
                    }
                }
            }));
    }
}

function load(id, context, callback) {
    d3.json('https://api.github.com/gists/' + id)
        .on('load', onLoad)
        .on('error', onError)
        .get();

    function onLoad(json) { callback(null, json); }
    function onError(err) { callback(err, null); }
}