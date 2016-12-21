var getUrlVar = function(key) {
    var result = new RegExp(key + "=([^&]*)", "i").exec(window.location.search);
    return result && unescape(result[1]) || "";
};

var getIDFromURL = function(key) {
    var result = new RegExp(key + "/([0-9a-zA-Z\-]*)", "i").exec(window.location.pathname);
    if (result === 'new') {
        return '';
    }
    return result && unescape(result[1]) || '';
};
