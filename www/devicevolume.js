var exec = require("cordova/exec");

var DeviceVolume = {

    getDeviceVolume: function (callback) {
        exec(callback, null, 'DeviceVolume', 'getDeviceVolume', []);
    },

    setDeviceVolume: function (volume) {
        exec(null, null, 'DeviceVolume', 'setDeviceVolume', [volume]);
    },

    setDeviceVolumeChangeCallback: function (callback) {
        exec(callback, null, 'DeviceVolume', 'setDeviceVolumeChangeCallback', []);
    }

};

module.exports = DeviceVolume;