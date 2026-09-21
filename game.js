
var Module;

if (typeof Module === 'undefined') Module = eval('(function() { try { return Module || {} } catch(e) { return {} } })()');

if (!Module.expectedDataFileDownloads) {
  Module.expectedDataFileDownloads = 0;
  Module.finishedDataFileDownloads = 0;
}
Module.expectedDataFileDownloads++;
(function() {
 var loadPackage = function(metadata) {

  var PACKAGE_PATH;
  if (typeof window === 'object') {
    PACKAGE_PATH = window['encodeURIComponent'](window.location.pathname.toString().substring(0, window.location.pathname.toString().lastIndexOf('/')) + '/');
  } else if (typeof location !== 'undefined') {
      // worker
      PACKAGE_PATH = encodeURIComponent(location.pathname.toString().substring(0, location.pathname.toString().lastIndexOf('/')) + '/');
    } else {
      throw 'using preloaded data can only be done on a web page or in a web worker';
    }
    var PACKAGE_NAME = 'game.data';
    var REMOTE_PACKAGE_BASE = 'game.data';
    if (typeof Module['locateFilePackage'] === 'function' && !Module['locateFile']) {
      Module['locateFile'] = Module['locateFilePackage'];
      Module.printErr('warning: you defined Module.locateFilePackage, that has been renamed to Module.locateFile (using your locateFilePackage for now)');
    }
    var REMOTE_PACKAGE_NAME = typeof Module['locateFile'] === 'function' ?
    Module['locateFile'](REMOTE_PACKAGE_BASE) :
    ((Module['filePackagePrefixURL'] || '') + REMOTE_PACKAGE_BASE);

    var REMOTE_PACKAGE_SIZE = metadata.remote_package_size;
    var PACKAGE_UUID = metadata.package_uuid;

    function fetchRemotePackage(packageName, packageSize, callback, errback) {
      var xhr = new XMLHttpRequest();
      xhr.open('GET', packageName, true);
      xhr.responseType = 'arraybuffer';
      xhr.onprogress = function(event) {
        var url = packageName;
        var size = packageSize;
        if (event.total) size = event.total;
        if (event.loaded) {
          if (!xhr.addedTotal) {
            xhr.addedTotal = true;
            if (!Module.dataFileDownloads) Module.dataFileDownloads = {};
            Module.dataFileDownloads[url] = {
              loaded: event.loaded,
              total: size
            };
          } else {
            Module.dataFileDownloads[url].loaded = event.loaded;
          }
          var total = 0;
          var loaded = 0;
          var num = 0;
          for (var download in Module.dataFileDownloads) {
            var data = Module.dataFileDownloads[download];
            total += data.total;
            loaded += data.loaded;
            num++;
          }
          total = Math.ceil(total * Module.expectedDataFileDownloads/num);
          if (Module['setStatus']) Module['setStatus']('Downloading data... (' + loaded + '/' + total + ')');
        } else if (!Module.dataFileDownloads) {
          if (Module['setStatus']) Module['setStatus']('Downloading data...');
        }
      };
      xhr.onerror = function(event) {
        throw new Error("NetworkError for: " + packageName);
      }
      xhr.onload = function(event) {
        if (xhr.status == 200 || xhr.status == 304 || xhr.status == 206 || (xhr.status == 0 && xhr.response)) { // file URLs can return 0
          var packageData = xhr.response;
          callback(packageData);
        } else {
          throw new Error(xhr.statusText + " : " + xhr.responseURL);
        }
      };
      xhr.send(null);
    };

    function handleError(error) {
      console.error('package error:', error);
    };

    function runWithFS() {

      function assert(check, msg) {
        if (!check) throw msg + new Error().stack;
      }
      Module['FS_createPath']('/', '.git', true, true);
      Module['FS_createPath']('/.git', 'hooks', true, true);
      Module['FS_createPath']('/.git', 'info', true, true);
      Module['FS_createPath']('/.git', 'logs', true, true);
      Module['FS_createPath']('/.git/logs', 'refs', true, true);
      Module['FS_createPath']('/.git/logs/refs', 'heads', true, true);
      Module['FS_createPath']('/.git/logs/refs', 'remotes', true, true);
      Module['FS_createPath']('/.git/logs/refs/remotes', 'origin', true, true);
      Module['FS_createPath']('/.git', 'objects', true, true);
      Module['FS_createPath']('/.git/objects', '03', true, true);
      Module['FS_createPath']('/.git/objects', '04', true, true);
      Module['FS_createPath']('/.git/objects', '07', true, true);
      Module['FS_createPath']('/.git/objects', '08', true, true);
      Module['FS_createPath']('/.git/objects', '09', true, true);
      Module['FS_createPath']('/.git/objects', '0d', true, true);
      Module['FS_createPath']('/.git/objects', '0e', true, true);
      Module['FS_createPath']('/.git/objects', '10', true, true);
      Module['FS_createPath']('/.git/objects', '12', true, true);
      Module['FS_createPath']('/.git/objects', '13', true, true);
      Module['FS_createPath']('/.git/objects', '15', true, true);
      Module['FS_createPath']('/.git/objects', '16', true, true);
      Module['FS_createPath']('/.git/objects', '17', true, true);
      Module['FS_createPath']('/.git/objects', '18', true, true);
      Module['FS_createPath']('/.git/objects', '19', true, true);
      Module['FS_createPath']('/.git/objects', '1c', true, true);
      Module['FS_createPath']('/.git/objects', '1d', true, true);
      Module['FS_createPath']('/.git/objects', '1e', true, true);
      Module['FS_createPath']('/.git/objects', '1f', true, true);
      Module['FS_createPath']('/.git/objects', '2b', true, true);
      Module['FS_createPath']('/.git/objects', '2d', true, true);
      Module['FS_createPath']('/.git/objects', '2e', true, true);
      Module['FS_createPath']('/.git/objects', '30', true, true);
      Module['FS_createPath']('/.git/objects', '34', true, true);
      Module['FS_createPath']('/.git/objects', '36', true, true);
      Module['FS_createPath']('/.git/objects', '37', true, true);
      Module['FS_createPath']('/.git/objects', '38', true, true);
      Module['FS_createPath']('/.git/objects', '39', true, true);
      Module['FS_createPath']('/.git/objects', '3e', true, true);
      Module['FS_createPath']('/.git/objects', '41', true, true);
      Module['FS_createPath']('/.git/objects', '42', true, true);
      Module['FS_createPath']('/.git/objects', '45', true, true);
      Module['FS_createPath']('/.git/objects', '47', true, true);
      Module['FS_createPath']('/.git/objects', '48', true, true);
      Module['FS_createPath']('/.git/objects', '4c', true, true);
      Module['FS_createPath']('/.git/objects', '54', true, true);
      Module['FS_createPath']('/.git/objects', '59', true, true);
      Module['FS_createPath']('/.git/objects', '5c', true, true);
      Module['FS_createPath']('/.git/objects', '61', true, true);
      Module['FS_createPath']('/.git/objects', '63', true, true);
      Module['FS_createPath']('/.git/objects', '64', true, true);
      Module['FS_createPath']('/.git/objects', '69', true, true);
      Module['FS_createPath']('/.git/objects', '6a', true, true);
      Module['FS_createPath']('/.git/objects', '6f', true, true);
      Module['FS_createPath']('/.git/objects', '71', true, true);
      Module['FS_createPath']('/.git/objects', '75', true, true);
      Module['FS_createPath']('/.git/objects', '76', true, true);
      Module['FS_createPath']('/.git/objects', '7a', true, true);
      Module['FS_createPath']('/.git/objects', '7e', true, true);
      Module['FS_createPath']('/.git/objects', '83', true, true);
      Module['FS_createPath']('/.git/objects', '84', true, true);
      Module['FS_createPath']('/.git/objects', '85', true, true);
      Module['FS_createPath']('/.git/objects', '88', true, true);
      Module['FS_createPath']('/.git/objects', '89', true, true);
      Module['FS_createPath']('/.git/objects', '8a', true, true);
      Module['FS_createPath']('/.git/objects', '8c', true, true);
      Module['FS_createPath']('/.git/objects', '8e', true, true);
      Module['FS_createPath']('/.git/objects', '91', true, true);
      Module['FS_createPath']('/.git/objects', '94', true, true);
      Module['FS_createPath']('/.git/objects', '95', true, true);
      Module['FS_createPath']('/.git/objects', '96', true, true);
      Module['FS_createPath']('/.git/objects', '97', true, true);
      Module['FS_createPath']('/.git/objects', '98', true, true);
      Module['FS_createPath']('/.git/objects', '99', true, true);
      Module['FS_createPath']('/.git/objects', '9a', true, true);
      Module['FS_createPath']('/.git/objects', '9b', true, true);
      Module['FS_createPath']('/.git/objects', '9d', true, true);
      Module['FS_createPath']('/.git/objects', '9e', true, true);
      Module['FS_createPath']('/.git/objects', 'a1', true, true);
      Module['FS_createPath']('/.git/objects', 'a2', true, true);
      Module['FS_createPath']('/.git/objects', 'a4', true, true);
      Module['FS_createPath']('/.git/objects', 'a5', true, true);
      Module['FS_createPath']('/.git/objects', 'a7', true, true);
      Module['FS_createPath']('/.git/objects', 'aa', true, true);
      Module['FS_createPath']('/.git/objects', 'b0', true, true);
      Module['FS_createPath']('/.git/objects', 'b2', true, true);
      Module['FS_createPath']('/.git/objects', 'b6', true, true);
      Module['FS_createPath']('/.git/objects', 'b7', true, true);
      Module['FS_createPath']('/.git/objects', 'bc', true, true);
      Module['FS_createPath']('/.git/objects', 'bd', true, true);
      Module['FS_createPath']('/.git/objects', 'c1', true, true);
      Module['FS_createPath']('/.git/objects', 'c3', true, true);
      Module['FS_createPath']('/.git/objects', 'c6', true, true);
      Module['FS_createPath']('/.git/objects', 'c9', true, true);
      Module['FS_createPath']('/.git/objects', 'ca', true, true);
      Module['FS_createPath']('/.git/objects', 'cb', true, true);
      Module['FS_createPath']('/.git/objects', 'cc', true, true);
      Module['FS_createPath']('/.git/objects', 'cd', true, true);
      Module['FS_createPath']('/.git/objects', 'ce', true, true);
      Module['FS_createPath']('/.git/objects', 'd1', true, true);
      Module['FS_createPath']('/.git/objects', 'd2', true, true);
      Module['FS_createPath']('/.git/objects', 'd3', true, true);
      Module['FS_createPath']('/.git/objects', 'd8', true, true);
      Module['FS_createPath']('/.git/objects', 'da', true, true);
      Module['FS_createPath']('/.git/objects', 'dc', true, true);
      Module['FS_createPath']('/.git/objects', 'df', true, true);
      Module['FS_createPath']('/.git/objects', 'e2', true, true);
      Module['FS_createPath']('/.git/objects', 'e6', true, true);
      Module['FS_createPath']('/.git/objects', 'e9', true, true);
      Module['FS_createPath']('/.git/objects', 'ed', true, true);
      Module['FS_createPath']('/.git/objects', 'ef', true, true);
      Module['FS_createPath']('/.git/objects', 'f0', true, true);
      Module['FS_createPath']('/.git/objects', 'f4', true, true);
      Module['FS_createPath']('/.git/objects', 'f6', true, true);
      Module['FS_createPath']('/.git/objects', 'f8', true, true);
      Module['FS_createPath']('/.git/objects', 'fb', true, true);
      Module['FS_createPath']('/.git/objects', 'fc', true, true);
      Module['FS_createPath']('/.git/objects', 'ff', true, true);
      Module['FS_createPath']('/.git/objects', 'info', true, true);
      Module['FS_createPath']('/.git/objects', 'pack', true, true);
      Module['FS_createPath']('/.git', 'refs', true, true);
      Module['FS_createPath']('/.git/refs', 'heads', true, true);
      Module['FS_createPath']('/.git/refs', 'remotes', true, true);
      Module['FS_createPath']('/.git/refs/remotes', 'origin', true, true);
      Module['FS_createPath']('/.git/refs', 'tags', true, true);
      Module['FS_createPath']('/', 'audio', true, true);
      Module['FS_createPath']('/audio', 'Effekte', true, true);
      Module['FS_createPath']('/', 'libraries', true, true);
      Module['FS_createPath']('/libraries', 'sti', true, true);
      Module['FS_createPath']('/libraries/sti', 'plugins', true, true);
      Module['FS_createPath']('/', 'script', true, true);
      Module['FS_createPath']('/', 'sprites', true, true);
      Module['FS_createPath']('/sprites', 'Chapter1', true, true);
      Module['FS_createPath']('/sprites', 'Fight', true, true);
      Module['FS_createPath']('/sprites', 'Keys', true, true);
      Module['FS_createPath']('/sprites', 'Menu', true, true);
      Module['FS_createPath']('/sprites', 'intro', true, true);
      Module['FS_createPath']('/sprites/intro', 'logo', true, true);
      Module['FS_createPath']('/', 'tilemaps', true, true);

      function DataRequest(start, end, crunched, audio) {
        this.start = start;
        this.end = end;
        this.crunched = crunched;
        this.audio = audio;
      }
      DataRequest.prototype = {
        requests: {},
        open: function(mode, name) {
          this.name = name;
          this.requests[name] = this;
          Module['addRunDependency']('fp ' + this.name);
        },
        send: function() {},
        onload: function() {
          var byteArray = this.byteArray.subarray(this.start, this.end);

          this.finish(byteArray);

        },
        finish: function(byteArray) {
          var that = this;

        Module['FS_createDataFile'](this.name, null, byteArray, true, true, true); // canOwn this data in the filesystem, it is a slide into the heap that will never change
        Module['removeRunDependency']('fp ' + that.name);

        this.requests[this.name] = null;
      }
    };

    var files = metadata.files;
    for (i = 0; i < files.length; ++i) {
      new DataRequest(files[i].start, files[i].end, files[i].crunched, files[i].audio).open('GET', files[i].filename);
    }


    var indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB;
    var IDB_RO = "readonly";
    var IDB_RW = "readwrite";
    var DB_NAME = "EM_PRELOAD_CACHE";
    var DB_VERSION = 1;
    var METADATA_STORE_NAME = 'METADATA';
    var PACKAGE_STORE_NAME = 'PACKAGES';
    function openDatabase(callback, errback) {
      try {
        var openRequest = indexedDB.open(DB_NAME, DB_VERSION);
      } catch (e) {
        return errback(e);
      }
      openRequest.onupgradeneeded = function(event) {
        var db = event.target.result;

        if(db.objectStoreNames.contains(PACKAGE_STORE_NAME)) {
          db.deleteObjectStore(PACKAGE_STORE_NAME);
        }
        var packages = db.createObjectStore(PACKAGE_STORE_NAME);

        if(db.objectStoreNames.contains(METADATA_STORE_NAME)) {
          db.deleteObjectStore(METADATA_STORE_NAME);
        }
        var metadata = db.createObjectStore(METADATA_STORE_NAME);
      };
      openRequest.onsuccess = function(event) {
        var db = event.target.result;
        callback(db);
      };
      openRequest.onerror = function(error) {
        errback(error);
      };
    };

    /* Check if there's a cached package, and if so whether it's the latest available */
    function checkCachedPackage(db, packageName, callback, errback) {
      var transaction = db.transaction([METADATA_STORE_NAME], IDB_RO);
      var metadata = transaction.objectStore(METADATA_STORE_NAME);

      var getRequest = metadata.get("metadata/" + packageName);
      getRequest.onsuccess = function(event) {
        var result = event.target.result;
        if (!result) {
          return callback(false);
        } else {
          return callback(PACKAGE_UUID === result.uuid);
        }
      };
      getRequest.onerror = function(error) {
        errback(error);
      };
    };

    function fetchCachedPackage(db, packageName, callback, errback) {
      var transaction = db.transaction([PACKAGE_STORE_NAME], IDB_RO);
      var packages = transaction.objectStore(PACKAGE_STORE_NAME);

      var getRequest = packages.get("package/" + packageName);
      getRequest.onsuccess = function(event) {
        var result = event.target.result;
        callback(result);
      };
      getRequest.onerror = function(error) {
        errback(error);
      };
    };

    function cacheRemotePackage(db, packageName, packageData, packageMeta, callback, errback) {
      var transaction_packages = db.transaction([PACKAGE_STORE_NAME], IDB_RW);
      var packages = transaction_packages.objectStore(PACKAGE_STORE_NAME);

      var putPackageRequest = packages.put(packageData, "package/" + packageName);
      putPackageRequest.onsuccess = function(event) {
        var transaction_metadata = db.transaction([METADATA_STORE_NAME], IDB_RW);
        var metadata = transaction_metadata.objectStore(METADATA_STORE_NAME);
        var putMetadataRequest = metadata.put(packageMeta, "metadata/" + packageName);
        putMetadataRequest.onsuccess = function(event) {
          callback(packageData);
        };
        putMetadataRequest.onerror = function(error) {
          errback(error);
        };
      };
      putPackageRequest.onerror = function(error) {
        errback(error);
      };
    };

    function processPackageData(arrayBuffer) {
      Module.finishedDataFileDownloads++;
      assert(arrayBuffer, 'Loading data file failed.');
      assert(arrayBuffer instanceof ArrayBuffer, 'bad input to processPackageData');
      var byteArray = new Uint8Array(arrayBuffer);
      var curr;

        // copy the entire loaded file into a spot in the heap. Files will refer to slices in that. They cannot be freed though
        // (we may be allocating before malloc is ready, during startup).
        if (Module['SPLIT_MEMORY']) Module.printErr('warning: you should run the file packager with --no-heap-copy when SPLIT_MEMORY is used, otherwise copying into the heap may fail due to the splitting');
        var ptr = Module['getMemory'](byteArray.length);
        Module['HEAPU8'].set(byteArray, ptr);
        DataRequest.prototype.byteArray = Module['HEAPU8'].subarray(ptr, ptr+byteArray.length);

        var files = metadata.files;
        for (i = 0; i < files.length; ++i) {
          DataRequest.prototype.requests[files[i].filename].onload();
        }
        Module['removeRunDependency']('datafile_game.data');

      };
      Module['addRunDependency']('datafile_game.data');

      if (!Module.preloadResults) Module.preloadResults = {};

      function preloadFallback(error) {
        console.error(error);
        console.error('falling back to default preload behavior');
        fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE, processPackageData, handleError);
      };

      openDatabase(
        function(db) {
          checkCachedPackage(db, PACKAGE_PATH + PACKAGE_NAME,
            function(useCached) {
              Module.preloadResults[PACKAGE_NAME] = {fromCache: useCached};
              if (useCached) {
                console.info('loading ' + PACKAGE_NAME + ' from cache');
                fetchCachedPackage(db, PACKAGE_PATH + PACKAGE_NAME, processPackageData, preloadFallback);
              } else {
                console.info('loading ' + PACKAGE_NAME + ' from remote');
                fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE,
                  function(packageData) {
                    cacheRemotePackage(db, PACKAGE_PATH + PACKAGE_NAME, packageData, {uuid:PACKAGE_UUID}, processPackageData,
                      function(error) {
                        console.error(error);
                        processPackageData(packageData);
                      });
                  }
                  , preloadFallback);
              }
            }
            , preloadFallback);
        }
        , preloadFallback);

      if (Module['setStatus']) Module['setStatus']('Downloading...');

    }
    if (Module['calledRun']) {
      runWithFS();
    } else {
      if (!Module['preRun']) Module['preRun'] = [];
      Module["preRun"].push(runWithFS); // FS is not initialized yet, wait for it
    }

  }
  loadPackage({"package_uuid":"4ee7c76c-ca1c-41a0-b184-e66d3445c120","remote_package_size":5818550,"files":[{"filename":"/.git/COMMIT_EDITMSG","crunched":0,"start":0,"end":30,"audio":false},{"filename":"/.git/FETCH_HEAD","crunched":0,"start":30,"end":132,"audio":false},{"filename":"/.git/HEAD","crunched":0,"start":132,"end":153,"audio":false},{"filename":"/.git/ORIG_HEAD","crunched":0,"start":153,"end":194,"audio":false},{"filename":"/.git/config","crunched":0,"start":194,"end":457,"audio":false},{"filename":"/.git/description","crunched":0,"start":457,"end":530,"audio":false},{"filename":"/.git/hooks/applypatch-msg.sample","crunched":0,"start":530,"end":1008,"audio":false},{"filename":"/.git/hooks/commit-msg.sample","crunched":0,"start":1008,"end":2980,"audio":false},{"filename":"/.git/hooks/fsmonitor-watchman.sample","crunched":0,"start":2980,"end":7591,"audio":false},{"filename":"/.git/hooks/post-update.sample","crunched":0,"start":7591,"end":7780,"audio":false},{"filename":"/.git/hooks/pre-applypatch.sample","crunched":0,"start":7780,"end":8204,"audio":false},{"filename":"/.git/hooks/pre-commit.sample","crunched":0,"start":8204,"end":9853,"audio":false},{"filename":"/.git/hooks/pre-merge-commit.sample","crunched":0,"start":9853,"end":10269,"audio":false},{"filename":"/.git/hooks/pre-push.sample","crunched":0,"start":10269,"end":11643,"audio":false},{"filename":"/.git/hooks/pre-rebase.sample","crunched":0,"start":11643,"end":16541,"audio":false},{"filename":"/.git/hooks/pre-receive.sample","crunched":0,"start":16541,"end":17085,"audio":false},{"filename":"/.git/hooks/prepare-commit-msg.sample","crunched":0,"start":17085,"end":18577,"audio":false},{"filename":"/.git/hooks/push-to-checkout.sample","crunched":0,"start":18577,"end":21360,"audio":false},{"filename":"/.git/hooks/sendemail-validate.sample","crunched":0,"start":21360,"end":23668,"audio":false},{"filename":"/.git/hooks/update.sample","crunched":0,"start":23668,"end":27318,"audio":false},{"filename":"/.git/index","crunched":0,"start":27318,"end":32974,"audio":false},{"filename":"/.git/info/exclude","crunched":0,"start":32974,"end":33214,"audio":false},{"filename":"/.git/logs/HEAD","crunched":0,"start":33214,"end":34529,"audio":false},{"filename":"/.git/logs/refs/heads/main","crunched":0,"start":34529,"end":35033,"audio":false},{"filename":"/.git/logs/refs/remotes/origin/HEAD","crunched":0,"start":35033,"end":35171,"audio":false},{"filename":"/.git/logs/refs/remotes/origin/main","crunched":0,"start":35171,"end":35645,"audio":false},{"filename":"/.git/objects/03/8d0d22a63b99f2b13644ca764ceb3d953aaf4a","crunched":0,"start":35645,"end":35795,"audio":false},{"filename":"/.git/objects/04/90588f3406b503494085ea99291f1c36166ee3","crunched":0,"start":35795,"end":36733,"audio":false},{"filename":"/.git/objects/07/d0fd80a6115186186a924c5b8760a69b9e7409","crunched":0,"start":36733,"end":36949,"audio":false},{"filename":"/.git/objects/08/0225907f571910b6f03cb4cf0a04e9fae2786f","crunched":0,"start":36949,"end":37281,"audio":false},{"filename":"/.git/objects/09/93fe07ff31993c3375dc39905de26b509005ab","crunched":0,"start":37281,"end":37542,"audio":false},{"filename":"/.git/objects/0d/22189e8ce826fa849babd869d1b580a50de7c1","crunched":0,"start":37542,"end":37627,"audio":false},{"filename":"/.git/objects/0e/edad42732816cc66304f28caa04ebcc552fc8d","crunched":0,"start":37627,"end":37995,"audio":false},{"filename":"/.git/objects/10/4d6ebc9e1a45d15c34d8e9556a58ae0ee479d1","crunched":0,"start":37995,"end":38975,"audio":false},{"filename":"/.git/objects/10/ebb41d28a2dd8ec332970c0b3b2cac0e11aaf6","crunched":0,"start":38975,"end":39256,"audio":false},{"filename":"/.git/objects/12/2daa3c0bfc921555c99fa8ef038aa74ba8d9d9","crunched":0,"start":39256,"end":39406,"audio":false},{"filename":"/.git/objects/13/b5610ee1e8bbd1dfae672c4b634ceedea895a9","crunched":0,"start":39406,"end":41324,"audio":false},{"filename":"/.git/objects/15/a5d83667d6a78bdeb72aca3ed15d2876fe79d0","crunched":0,"start":41324,"end":41539,"audio":false},{"filename":"/.git/objects/16/f21cc7742a847120f5e96032c8e38df28b9f75","crunched":0,"start":41539,"end":41665,"audio":false},{"filename":"/.git/objects/17/84c9e3b2f1d775ded55843c2e9b53559179e7a","crunched":0,"start":41665,"end":58814,"audio":false},{"filename":"/.git/objects/17/b7a06e2803d25a64b28eaff270379d90ec5bc5","crunched":0,"start":58814,"end":59030,"audio":false},{"filename":"/.git/objects/18/cd6e819cc9d196ba9e1779cbf0cd8244fefade","crunched":0,"start":59030,"end":59746,"audio":false},{"filename":"/.git/objects/18/f48db3765b8670f36b351b483c400897abb002","crunched":0,"start":59746,"end":59830,"audio":false},{"filename":"/.git/objects/19/749f1d5df521a408c946973afbb681e9acfea1","crunched":0,"start":59830,"end":60636,"audio":false},{"filename":"/.git/objects/1c/642e79342ceddf047f6dacf579dab8ff91a6b9","crunched":0,"start":60636,"end":61540,"audio":false},{"filename":"/.git/objects/1d/12a9afeb0fa9d44c63ba99885c317dc36f50c9","crunched":0,"start":61540,"end":62562,"audio":false},{"filename":"/.git/objects/1d/4b828dc7fbeb236dbf72fc249ab46929ccc491","crunched":0,"start":62562,"end":64933,"audio":false},{"filename":"/.git/objects/1d/7fb7343676b8520b631e53ddaa5f72dbe4e1cd","crunched":0,"start":64933,"end":65145,"audio":false},{"filename":"/.git/objects/1e/cad7c0c24f2a681a934f06ef1cd6b229925b4e","crunched":0,"start":65145,"end":65273,"audio":false},{"filename":"/.git/objects/1f/6622eb1a7f7a57a6a9c5a70cb9466ac5ecd2d5","crunched":0,"start":65273,"end":65550,"audio":false},{"filename":"/.git/objects/2b/f8235d5c37a000100e0d326749e86729845b22","crunched":0,"start":65550,"end":66011,"audio":false},{"filename":"/.git/objects/2d/5a1aaabd045ec7281c3942891e9efcbb46d07c","crunched":0,"start":66011,"end":66169,"audio":false},{"filename":"/.git/objects/2e/58b28806a97da17472c018fa3d1343ba6451d9","crunched":0,"start":66169,"end":66255,"audio":false},{"filename":"/.git/objects/30/2b3322c68122dd371b1e172200020f04ad1bf4","crunched":0,"start":66255,"end":68071,"audio":false},{"filename":"/.git/objects/34/d5c0aa582d9b71c61a71364f473822f5eacca7","crunched":0,"start":68071,"end":68226,"audio":false},{"filename":"/.git/objects/36/193b641f402473fa78ac083fea6136080e51e9","crunched":0,"start":68226,"end":74719,"audio":false},{"filename":"/.git/objects/37/d5dc0e04d693af56ef367899ade5ceb91af527","crunched":0,"start":74719,"end":74963,"audio":false},{"filename":"/.git/objects/38/0849aaa0a51597d08a39fffe45a1b37d29f75f","crunched":0,"start":74963,"end":75985,"audio":false},{"filename":"/.git/objects/39/33754c48d8854ae7beae27597a9dab794764f5","crunched":0,"start":75985,"end":77007,"audio":false},{"filename":"/.git/objects/3e/221c37ae9382667146e002da0185b609df9d42","crunched":0,"start":77007,"end":78750,"audio":false},{"filename":"/.git/objects/41/3be53a7973401fa7f8fafc82c634d9f2b73d4f","crunched":0,"start":78750,"end":79029,"audio":false},{"filename":"/.git/objects/42/3f7c57f7eaa9d420ca605450a9e07ccce5a674","crunched":0,"start":79029,"end":79526,"audio":false},{"filename":"/.git/objects/42/6b0ab5e2e835298b85bdd07d9821beaa818d22","crunched":0,"start":79526,"end":79782,"audio":false},{"filename":"/.git/objects/45/34234b06b257d3f07932d9da59f083a73c61c9","crunched":0,"start":79782,"end":80115,"audio":false},{"filename":"/.git/objects/45/a8b7e8c00648d8cd6455fdc4f4a8d330836c18","crunched":0,"start":80115,"end":80415,"audio":false},{"filename":"/.git/objects/47/a49cff923672e9e9aaefbfbff348982f078fa1","crunched":0,"start":80415,"end":81281,"audio":false},{"filename":"/.git/objects/48/fbcb942095f8dd12bd3436b614a96df9ff5233","crunched":0,"start":81281,"end":85037,"audio":false},{"filename":"/.git/objects/4c/1b66a4f9e80468f436fd9e4e6c2adee329d3a4","crunched":0,"start":85037,"end":85217,"audio":false},{"filename":"/.git/objects/54/e11094cd4293d7d493d3a2286ec18ac3456383","crunched":0,"start":85217,"end":87510,"audio":false},{"filename":"/.git/objects/59/1bd27f17e8041724f46aea8c4eb2f6e12558ea","crunched":0,"start":87510,"end":104595,"audio":false},{"filename":"/.git/objects/59/361b157085be8a9ac5c39451ebe5fd5dc2d0e5","crunched":0,"start":104595,"end":105322,"audio":false},{"filename":"/.git/objects/5c/b4a431714b6e4bd4edb97882eb618fe814b218","crunched":0,"start":105322,"end":105974,"audio":false},{"filename":"/.git/objects/61/176d8fb1e8016f89acb4ab345acffcb42cb1ac","crunched":0,"start":105974,"end":106818,"audio":false},{"filename":"/.git/objects/63/5ada69d9e17406c14a8c061bc42a065d6695d9","crunched":0,"start":106818,"end":112505,"audio":false},{"filename":"/.git/objects/63/64f29d14cc4e5fe4ebe2852b6e25ad70b5f03d","crunched":0,"start":112505,"end":114777,"audio":false},{"filename":"/.git/objects/64/6a224db47b76fdd58bfe38d1d2fcec6020ec30","crunched":0,"start":114777,"end":131547,"audio":false},{"filename":"/.git/objects/69/ed68125eacb81ae4859a8badfcbc2f8b968e2e","crunched":0,"start":131547,"end":132623,"audio":false},{"filename":"/.git/objects/6a/cf8d6325558d68730b750fff9f76c74789432c","crunched":0,"start":132623,"end":133101,"audio":false},{"filename":"/.git/objects/6f/a360eb475db3c2e6e7c37b22f965cac77502a5","crunched":0,"start":133101,"end":133503,"audio":false},{"filename":"/.git/objects/71/6cf5acc7c1eaacc2336b4523e61fb31aed6de3","crunched":0,"start":133503,"end":133646,"audio":false},{"filename":"/.git/objects/71/e8e306b952ce39afcec8ef311d379d7ec7fa5f","crunched":0,"start":133646,"end":136135,"audio":false},{"filename":"/.git/objects/75/f2e69a9061eca5ca0eb85982090f7436c0fde0","crunched":0,"start":136135,"end":137031,"audio":false},{"filename":"/.git/objects/76/c257a3a608701bd68c53121d0cd8b447f91647","crunched":0,"start":137031,"end":137493,"audio":false},{"filename":"/.git/objects/7a/6a97d4a7a334d6c98c0f4bea4c5d7834c7fae0","crunched":0,"start":137493,"end":141058,"audio":false},{"filename":"/.git/objects/7a/e27e28fd73009b6b1934e74868c2799deef432","crunched":0,"start":141058,"end":141459,"audio":false},{"filename":"/.git/objects/7e/1cf23e74b8696b1cbafc8b3caec4719bfa0f73","crunched":0,"start":141459,"end":141597,"audio":false},{"filename":"/.git/objects/83/b07f5c0ec0170f2ab57f6550c61402e133f23d","crunched":0,"start":141597,"end":141897,"audio":false},{"filename":"/.git/objects/83/dd62035d5b59efee3de0fca1f6f404d568306b","crunched":0,"start":141897,"end":142174,"audio":false},{"filename":"/.git/objects/84/193280f4700fd80b8329f60f1af7d16f2336be","crunched":0,"start":142174,"end":142319,"audio":false},{"filename":"/.git/objects/85/352dde086585695253880c1eca12cddd165104","crunched":0,"start":142319,"end":143192,"audio":false},{"filename":"/.git/objects/88/4a1b7620e957e539f12071e61cd24298ebb5bc","crunched":0,"start":143192,"end":145132,"audio":false},{"filename":"/.git/objects/88/64971340c82dcd62a2e8349623776319fe752a","crunched":0,"start":145132,"end":146384,"audio":false},{"filename":"/.git/objects/89/0b279a4339b4e8a72b9e0498821e8bcbf45260","crunched":0,"start":146384,"end":150344,"audio":false},{"filename":"/.git/objects/8a/44f4856ee85cc9306939152a81306d5106a3d7","crunched":0,"start":150344,"end":150402,"audio":false},{"filename":"/.git/objects/8c/a1408c56f52191732c27aa24f17ee43b25770c","crunched":0,"start":150402,"end":151092,"audio":false},{"filename":"/.git/objects/8c/b3fd45d757b6774b23032a2f53d61d8cf6fe6e","crunched":0,"start":151092,"end":151185,"audio":false},{"filename":"/.git/objects/8e/875f76c03dfeb16466bf6de62061bbbe33375d","crunched":0,"start":151185,"end":151223,"audio":false},{"filename":"/.git/objects/91/27ade82849d5bc4fa24118cef0206129a5111e","crunched":0,"start":151223,"end":156280,"audio":false},{"filename":"/.git/objects/91/39b4bedb4502dafbaf4305c72427551d9c0c5f","crunched":0,"start":156280,"end":157033,"audio":false},{"filename":"/.git/objects/91/9e13a5ec6c94e01c5faa3e8a28ace3f486df33","crunched":0,"start":157033,"end":157412,"audio":false},{"filename":"/.git/objects/91/d2597157f318e4a4cbb9be57341b3b5fd6a822","crunched":0,"start":157412,"end":157700,"audio":false},{"filename":"/.git/objects/94/e25a6e5d7879eb72eb62755eb561293dc89c0c","crunched":0,"start":157700,"end":157784,"audio":false},{"filename":"/.git/objects/95/e857ad0c17df66dc0ffe45d5952b40f720ebe7","crunched":0,"start":157784,"end":160241,"audio":false},{"filename":"/.git/objects/96/5cdb4c12277a53469e64b068cc335e58e55b89","crunched":0,"start":160241,"end":163359,"audio":false},{"filename":"/.git/objects/97/d618c2a46d040446471785542f2c049520fa6f","crunched":0,"start":163359,"end":163989,"audio":false},{"filename":"/.git/objects/98/d3532d29e8e6a50e5c3a993fb656ff85492370","crunched":0,"start":163989,"end":164952,"audio":false},{"filename":"/.git/objects/99/b1921297ef0b146c4793405b9576b35ab705ef","crunched":0,"start":164952,"end":165034,"audio":false},{"filename":"/.git/objects/9a/7168929b85826ec5657aee94bcd4caac1ed9c6","crunched":0,"start":165034,"end":165843,"audio":false},{"filename":"/.git/objects/9b/aa000a1001476aa8562eca990b9a8d9c05b440","crunched":0,"start":165843,"end":166241,"audio":false},{"filename":"/.git/objects/9b/deb314612f739bcbba2808716a11ea524bdcae","crunched":0,"start":166241,"end":166428,"audio":false},{"filename":"/.git/objects/9d/b7363e0d729804ed2794f6c5b08d10e8309cfa","crunched":0,"start":166428,"end":166802,"audio":false},{"filename":"/.git/objects/9e/a112cd540f67335eb7bf4426bfb3014bcaf48e","crunched":0,"start":166802,"end":166856,"audio":false},{"filename":"/.git/objects/a1/57ebb43ef606b1dc25fd288f48a6cf0c0ce360","crunched":0,"start":166856,"end":167898,"audio":false},{"filename":"/.git/objects/a2/924fb60b2a4ddbc7b271ba071e0dbc3b043cdd","crunched":0,"start":167898,"end":167953,"audio":false},{"filename":"/.git/objects/a4/6cea3b13d364b1cae816fe9e6ebe11642a0377","crunched":0,"start":167953,"end":168199,"audio":false},{"filename":"/.git/objects/a5/2a9f3d1f956f442465f9582aa73cae81dc7314","crunched":0,"start":168199,"end":168253,"audio":false},{"filename":"/.git/objects/a7/79b2a5d86378c53e6a0aafe139be048825634e","crunched":0,"start":168253,"end":168637,"audio":false},{"filename":"/.git/objects/aa/3066141b241a9487937eaa68680d8f0b3885d3","crunched":0,"start":168637,"end":259380,"audio":false},{"filename":"/.git/objects/b0/aaf337575fd90cae948b9583cc4518911bf620","crunched":0,"start":259380,"end":262475,"audio":false},{"filename":"/.git/objects/b2/b1dbda7a4672a9bdbc710b3a4f6418e7c6786e","crunched":0,"start":262475,"end":268958,"audio":false},{"filename":"/.git/objects/b2/c93bd99de4d47bacd0b81b61cca4efdebc304f","crunched":0,"start":268958,"end":270521,"audio":false},{"filename":"/.git/objects/b6/3e668c59bb42c0ce86a144f45eeff577e737f9","crunched":0,"start":270521,"end":270767,"audio":false},{"filename":"/.git/objects/b7/a68190b5ee9c6fe1c75a95f5eb13a0b8be58cd","crunched":0,"start":270767,"end":274769,"audio":false},{"filename":"/.git/objects/bc/b60529e5782bf9149a30348d1b8b3259733d4f","crunched":0,"start":274769,"end":278570,"audio":false},{"filename":"/.git/objects/bd/0f6e17bb0a94160de75d59a7235c4e526441f9","crunched":0,"start":278570,"end":400743,"audio":false},{"filename":"/.git/objects/bd/9bade3de8dbfa5b6748a2f951fb750921771e2","crunched":0,"start":400743,"end":401156,"audio":false},{"filename":"/.git/objects/c1/07aa6af53e4c0e62649882156549e49279734c","crunched":0,"start":401156,"end":401806,"audio":false},{"filename":"/.git/objects/c1/809667964aa726fc1f553fcfdf6b2fe325189d","crunched":0,"start":401806,"end":401956,"audio":false},{"filename":"/.git/objects/c1/aca2124d9de03b75c4d77b9147a02743a33cad","crunched":0,"start":401956,"end":402004,"audio":false},{"filename":"/.git/objects/c3/1ec355b00c785dc63da5ab1f03befff77efbb6","crunched":0,"start":402004,"end":402639,"audio":false},{"filename":"/.git/objects/c6/c49d33ac73c222428fe76313a8bfc14f9d5bcf","crunched":0,"start":402639,"end":409003,"audio":false},{"filename":"/.git/objects/c6/d4148d95fc12229d6af7f27410f647c89358ce","crunched":0,"start":409003,"end":412945,"audio":false},{"filename":"/.git/objects/c9/becf9df7b62245e12094bc007b21ba8724b1e6","crunched":0,"start":412945,"end":413745,"audio":false},{"filename":"/.git/objects/ca/0d051896ba75e5729e5c69e7aeca57fd8f7e93","crunched":0,"start":413745,"end":413778,"audio":false},{"filename":"/.git/objects/cb/35a1dc091083a2f9c6fefc81228ffecf1d9567","crunched":0,"start":413778,"end":414492,"audio":false},{"filename":"/.git/objects/cb/898a0044b2024a03554e1122e9f0f567f6e34a","crunched":0,"start":414492,"end":415514,"audio":false},{"filename":"/.git/objects/cc/5a3def02c01ce55e24f6ae03433db6b04bf5cb","crunched":0,"start":415514,"end":416093,"audio":false},{"filename":"/.git/objects/cd/4ea0decce8636ed378d56f369806a80c2457de","crunched":0,"start":416093,"end":417111,"audio":false},{"filename":"/.git/objects/cd/783809b1a54267a3eaab588fbad4b1510b9b39","crunched":0,"start":417111,"end":417299,"audio":false},{"filename":"/.git/objects/ce/98e0c63cb9425fab22d91e66445499811fce4a","crunched":0,"start":417299,"end":420303,"audio":false},{"filename":"/.git/objects/ce/f68f4f5a1089a683f5aaadcb3e398052f5fb53","crunched":0,"start":420303,"end":420508,"audio":false},{"filename":"/.git/objects/d1/1130d013ef5f0189498224f854c0377addfd30","crunched":0,"start":420508,"end":421107,"audio":false},{"filename":"/.git/objects/d2/24816dcb8d9ee7947776897c2b958052abd6d1","crunched":0,"start":421107,"end":421450,"audio":false},{"filename":"/.git/objects/d3/7b1a74bde8d226335e52ac46082cc2ba3116d8","crunched":0,"start":421450,"end":421695,"audio":false},{"filename":"/.git/objects/d8/955a3f81d016f9faeecbd031c1cc55a6b605d7","crunched":0,"start":421695,"end":421845,"audio":false},{"filename":"/.git/objects/da/671b878a064dec660ed9903dd4f9433ea091ad","crunched":0,"start":421845,"end":422639,"audio":false},{"filename":"/.git/objects/dc/1bad3e3dbd8595f0d04c2e1b9236b018c6ed1b","crunched":0,"start":422639,"end":422861,"audio":false},{"filename":"/.git/objects/df/155e14602e1ccf259a393f39b606cfcb78eb2d","crunched":0,"start":422861,"end":434017,"audio":false},{"filename":"/.git/objects/e2/dfcd07c7f28c51cb434a808e155092debbba16","crunched":0,"start":434017,"end":436323,"audio":false},{"filename":"/.git/objects/e6/727066cf3106a7ca18a2fcb19c016903478db4","crunched":0,"start":436323,"end":436457,"audio":false},{"filename":"/.git/objects/e6/95ba5c11b65416fac749fb04caf97893f92c93","crunched":0,"start":436457,"end":436582,"audio":false},{"filename":"/.git/objects/e6/e5a8aa2efd385dd604af3e6d40692b2c452715","crunched":0,"start":436582,"end":437604,"audio":false},{"filename":"/.git/objects/e9/4e63ea0bdc49567b6e5366720743e4f6beefcb","crunched":0,"start":437604,"end":441567,"audio":false},{"filename":"/.git/objects/e9/63c9bb5f6c99303f8bf92ac03ca7fac635a18e","crunched":0,"start":441567,"end":444662,"audio":false},{"filename":"/.git/objects/ed/dcdde1ea3ecaa17a8808d7be86ee681f4909ef","crunched":0,"start":444662,"end":445293,"audio":false},{"filename":"/.git/objects/ef/415ce75c78569f1af370e443e0c0f1183e3868","crunched":0,"start":445293,"end":446315,"audio":false},{"filename":"/.git/objects/ef/4f5b1cda0d9d3af19137339b73a9b83970cce6","crunched":0,"start":446315,"end":446603,"audio":false},{"filename":"/.git/objects/f0/d20bbe73a943e2cb987f095d0b0167079e1e24","crunched":0,"start":446603,"end":446756,"audio":false},{"filename":"/.git/objects/f4/695cc40c8245be993c573a16d33efd26479d49","crunched":0,"start":446756,"end":451832,"audio":false},{"filename":"/.git/objects/f6/eb964bda973b1f0e4b3b9a43eed5ae4538d600","crunched":0,"start":451832,"end":453803,"audio":false},{"filename":"/.git/objects/f6/f5ee488fc87b4bd7f61abfbe4bbf71dee16cf2","crunched":0,"start":453803,"end":455160,"audio":false},{"filename":"/.git/objects/f8/625e1ad6d2fcb7ef42d9f1d3f69ebba4b06c2b","crunched":0,"start":455160,"end":455305,"audio":false},{"filename":"/.git/objects/f8/b6a17f6710dbb09c3aa98ecf3204a9e5c2d29a","crunched":0,"start":455305,"end":455585,"audio":false},{"filename":"/.git/objects/fb/f618c247810316586c72dc32a8a715f484b889","crunched":0,"start":455585,"end":455742,"audio":false},{"filename":"/.git/objects/fc/b185ec8daf0367849ef6a866ee8a3aaaeb7ecc","crunched":0,"start":455742,"end":455863,"audio":false},{"filename":"/.git/objects/ff/3c702f5b6e5a4ba2c3f379fd64b1bf4791d073","crunched":0,"start":455863,"end":456007,"audio":false},{"filename":"/.git/objects/ff/61e8a13be25fe60ba10f9172e9d165e5e217a7","crunched":0,"start":456007,"end":457745,"audio":false},{"filename":"/.git/objects/maintenance.lock","crunched":0,"start":457745,"end":457745,"audio":false},{"filename":"/.git/refs/heads/main","crunched":0,"start":457745,"end":457786,"audio":false},{"filename":"/.git/refs/remotes/origin/HEAD","crunched":0,"start":457786,"end":457816,"audio":false},{"filename":"/.git/refs/remotes/origin/main","crunched":0,"start":457816,"end":457857,"audio":false},{"filename":"/.luarc.json","crunched":0,"start":457857,"end":458340,"audio":false},{"filename":"/audio/Boss1Intro.ogg","crunched":0,"start":458340,"end":1565445,"audio":true},{"filename":"/audio/Boss1Loop.ogg","crunched":0,"start":1565445,"end":2007138,"audio":true},{"filename":"/audio/CyberJungleIntro.ogg","crunched":0,"start":2007138,"end":2181904,"audio":true},{"filename":"/audio/CyberJungleMain.ogg","crunched":0,"start":2181904,"end":4250209,"audio":true},{"filename":"/audio/CyberJungleÜbergang.ogg","crunched":0,"start":4250209,"end":5248879,"audio":true},{"filename":"/audio/Effekte/Schaden.wav","crunched":0,"start":5248879,"end":5369219,"audio":true},{"filename":"/audio/Effekte/switch.wav","crunched":0,"start":5369219,"end":5400993,"audio":true},{"filename":"/credits","crunched":0,"start":5400993,"end":5401103,"audio":false},{"filename":"/libraries/CameraMgr.lua","crunched":0,"start":5401103,"end":5409884,"audio":false},{"filename":"/libraries/anim8.lua","crunched":0,"start":5409884,"end":5418376,"audio":false},{"filename":"/libraries/push.lua","crunched":0,"start":5418376,"end":5427343,"audio":false},{"filename":"/libraries/sti/atlas.lua","crunched":0,"start":5427343,"end":5431718,"audio":false},{"filename":"/libraries/sti/graphics.lua","crunched":0,"start":5431718,"end":5433813,"audio":false},{"filename":"/libraries/sti/init.lua","crunched":0,"start":5433813,"end":5479918,"audio":false},{"filename":"/libraries/sti/plugins/box2d.lua","crunched":0,"start":5479918,"end":5489653,"audio":false},{"filename":"/libraries/sti/plugins/bump.lua","crunched":0,"start":5489653,"end":5495430,"audio":false},{"filename":"/libraries/sti/utils.lua","crunched":0,"start":5495430,"end":5500300,"audio":false},{"filename":"/main.lua","crunched":0,"start":5500300,"end":5502644,"audio":false},{"filename":"/script/chapter1.lua","crunched":0,"start":5502644,"end":5514206,"audio":false},{"filename":"/script/collsilision.lua","crunched":0,"start":5514206,"end":5516300,"audio":false},{"filename":"/script/fight.lua","crunched":0,"start":5516300,"end":5521257,"audio":false},{"filename":"/script/intro.lua","crunched":0,"start":5521257,"end":5531599,"audio":false},{"filename":"/script/menu.lua","crunched":0,"start":5531599,"end":5540025,"audio":false},{"filename":"/script/player.lua","crunched":0,"start":5540025,"end":5544860,"audio":false},{"filename":"/script/textbox.lua","crunched":0,"start":5544860,"end":5548314,"audio":false},{"filename":"/sprites/Chapter1/BumBum.png","crunched":0,"start":5548314,"end":5548480,"audio":false},{"filename":"/sprites/Chapter1/BösiSteini.png","crunched":0,"start":5548480,"end":5548864,"audio":false},{"filename":"/sprites/Chapter1/Fight.png","crunched":0,"start":5548864,"end":5549365,"audio":false},{"filename":"/sprites/Chapter1/Lüppen.png","crunched":0,"start":5549365,"end":5549600,"audio":false},{"filename":"/sprites/Chapter1/MsMauerFight.png","crunched":0,"start":5549600,"end":5550117,"audio":false},{"filename":"/sprites/Chapter1/Tilemap.png","crunched":0,"start":5550117,"end":5552041,"audio":false},{"filename":"/sprites/Comicoro.ttf","crunched":0,"start":5552041,"end":5591433,"audio":false},{"filename":"/sprites/EnterCommand.ttf","crunched":0,"start":5591433,"end":5631489,"audio":false},{"filename":"/sprites/Fight/Fight.ase","crunched":0,"start":5631489,"end":5633699,"audio":false},{"filename":"/sprites/Fight/Healthbar.png","crunched":0,"start":5633699,"end":5633845,"audio":false},{"filename":"/sprites/Fight/HealthbarGreen.png","crunched":0,"start":5633845,"end":5633975,"audio":false},{"filename":"/sprites/Fight/HealthbarRed.png","crunched":0,"start":5633975,"end":5634078,"audio":false},{"filename":"/sprites/Fight/UI.png","crunched":0,"start":5634078,"end":5634413,"audio":false},{"filename":"/sprites/Keys/K.png","crunched":0,"start":5634413,"end":5634538,"audio":false},{"filename":"/sprites/Keys/L.png","crunched":0,"start":5634538,"end":5634658,"audio":false},{"filename":"/sprites/Keys/X.png","crunched":0,"start":5634658,"end":5634785,"audio":false},{"filename":"/sprites/Keys/Y.png","crunched":0,"start":5634785,"end":5634912,"audio":false},{"filename":"/sprites/Menu/Settings.png","crunched":0,"start":5634912,"end":5635888,"audio":false},{"filename":"/sprites/Menu/TitelBild.png","crunched":0,"start":5635888,"end":5637697,"audio":false},{"filename":"/sprites/Menu/button.png","crunched":0,"start":5637697,"end":5637999,"audio":false},{"filename":"/sprites/Menu/buttonhover.png","crunched":0,"start":5637999,"end":5638302,"audio":false},{"filename":"/sprites/Menu/exit.png","crunched":0,"start":5638302,"end":5638493,"audio":false},{"filename":"/sprites/Menu/exithover.png","crunched":0,"start":5638493,"end":5638694,"audio":false},{"filename":"/sprites/Menu/prototype.ase","crunched":0,"start":5638694,"end":5642555,"audio":false},{"filename":"/sprites/Menu/settingsbutton.png","crunched":0,"start":5642555,"end":5642923,"audio":false},{"filename":"/sprites/Menu/settingsbuttonhover.png","crunched":0,"start":5642923,"end":5643287,"audio":false},{"filename":"/sprites/Sohnemann.png","crunched":0,"start":5643287,"end":5645643,"audio":false},{"filename":"/sprites/Spookyman.png","crunched":0,"start":5645643,"end":5653828,"audio":false},{"filename":"/sprites/Textbox.png","crunched":0,"start":5653828,"end":5654123,"audio":false},{"filename":"/sprites/Textboxbuffer.png","crunched":0,"start":5654123,"end":5654206,"audio":false},{"filename":"/sprites/TitelBild.ase","crunched":0,"start":5654206,"end":5656048,"audio":false},{"filename":"/sprites/TitelBild.png","crunched":0,"start":5656048,"end":5657521,"audio":false},{"filename":"/sprites/fight.png","crunched":0,"start":5657521,"end":5658755,"audio":false},{"filename":"/sprites/intro/CooleAnimation.png","crunched":0,"start":5658755,"end":5662648,"audio":false},{"filename":"/sprites/intro/DönermannMitFlei.png","crunched":0,"start":5662648,"end":5663590,"audio":false},{"filename":"/sprites/intro/DönermannOhneFlei.png","crunched":0,"start":5663590,"end":5664344,"audio":false},{"filename":"/sprites/intro/HansBack.png","crunched":0,"start":5664344,"end":5664701,"audio":false},{"filename":"/sprites/intro/HansMitHubschrauber.png","crunched":0,"start":5664701,"end":5665289,"audio":false},{"filename":"/sprites/intro/HansMitHut.png","crunched":0,"start":5665289,"end":5665884,"audio":false},{"filename":"/sprites/intro/Kitzelmonsta.png","crunched":0,"start":5665884,"end":5666337,"audio":false},{"filename":"/sprites/intro/Shield.png","crunched":0,"start":5666337,"end":5666534,"audio":false},{"filename":"/sprites/intro/Tilemap.png","crunched":0,"start":5666534,"end":5667201,"audio":false},{"filename":"/sprites/intro/logo/Animation.ase","crunched":0,"start":5667201,"end":5674571,"audio":false},{"filename":"/sprites/intro/logo/Background.png","crunched":0,"start":5674571,"end":5681047,"audio":false},{"filename":"/sprites/intro/logo/Waterfall.ase","crunched":0,"start":5681047,"end":5683491,"audio":false},{"filename":"/sprites/intro/logo/Waterfall.png","crunched":0,"start":5683491,"end":5685475,"audio":false},{"filename":"/tilemaps/Fight1.lua","crunched":0,"start":5685475,"end":5686990,"audio":false},{"filename":"/tilemaps/Fight1.tmx","crunched":0,"start":5686990,"end":5687648,"audio":false},{"filename":"/tilemaps/chapter1.lua","crunched":0,"start":5687648,"end":5710963,"audio":false},{"filename":"/tilemaps/chapter1.tmx","crunched":0,"start":5710963,"end":5724022,"audio":false},{"filename":"/tilemaps/holybibi.lua","crunched":0,"start":5724022,"end":5785131,"audio":false},{"filename":"/tilemaps/holybibi.tmx","crunched":0,"start":5785131,"end":5818550,"audio":false}]});

})();
