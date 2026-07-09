'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"admin/config.js": "f55e66dd8d6fdb39252be5c90763dde4",
"admin/index.html": "ecbb6569afacc05c74476d813e73d198",
"assets/AssetManifest.bin": "04d4f33a6c45192bbac0709cca01568a",
"assets/AssetManifest.bin.json": "ed2321f1e2381614e0f4803ffb713889",
"assets/AssetManifest.json": "b2a7e08ac24f7c1c186a0e70e08d75e7",
"assets/assets/books/volume-1781967123575-original.pdf": "aea9fb0760b63dd4e6ebc1d5e5b69d91",
"assets/assets/books/volume-1781967123575-page-001.jpg": "46af606ba2f5bff2320f8a00d8659beb",
"assets/assets/books/volume-1781967123575-page-002.jpg": "a15c78176bce868266a1890714cd0aee",
"assets/assets/books/volume-1781967123575-page-003.jpg": "effe339fdb3aec3d59f13c690f06f0d2",
"assets/assets/books/volume-1781967123575-page-004.jpg": "63df8295771104e8629c88c6085fb7a4",
"assets/assets/books/volume-1781967123575-page-005.jpg": "29e3fc5fd38300bccd46e94da36cc5ba",
"assets/assets/books/volume-1781967123575-page-006.jpg": "070d0b36055a425d9a1e0d88d0f33779",
"assets/assets/books/volume-1781967123575-page-007.jpg": "2e28fd045e205d3e95b7f5493172e182",
"assets/assets/books/volume-1781967123575-page-008.jpg": "6cb5452d10bca55711e8122711a94b83",
"assets/assets/books/volume-1782038650831-original.pdf": "5d38e391b56fd27fcbf2884314c0617e",
"assets/assets/books/volume-1782038650831-page-001.jpg": "e2ce0bf92fe268a0f1625ecdc45a6904",
"assets/assets/books/volume-1782038650831-page-002.jpg": "ced41824057d168bc2046a46396a4b19",
"assets/assets/books/volume-1782038650831-page-003.jpg": "5e5030f64f797fb8704895e0fcc1316d",
"assets/assets/books/volume-1782038650831-page-004.jpg": "dab71fe28c4c730b0d0e823412627143",
"assets/assets/books/volume-1782038650831-page-005.jpg": "29189a8216dac15b600d3b0c02253ae5",
"assets/assets/books/volume-1782038650831-page-006.jpg": "7410162d814c84fa3e838de21b534869",
"assets/assets/books/volume-1782038650831-page-007.jpg": "7fff1769e2d2b32bd211e7dff1ad861b",
"assets/assets/books/volume-1782038650831-page-008.jpg": "3177c993f17f3e231b0235411992fee8",
"assets/assets/books/volume-1782038749072-original.pdf": "a44aeffbc21cfe1fed714ae8df8e76a9",
"assets/assets/books/volume-1782038749072-page-001.jpg": "8ee917582523ec801ad81a81f4791f00",
"assets/assets/books/volume-1782038749072-page-002.jpg": "086e38e4f64b4a193cd85b746725f3cc",
"assets/assets/books/volume-1782038749072-page-003.jpg": "6b4d931a5058e5ccdc638ba041c0d8bf",
"assets/assets/books/volume-1782038749072-page-004.jpg": "4888e92c4b5a92edb7331442566556cb",
"assets/assets/books/volume-1782038749072-page-005.jpg": "fa166b67593b0130b8add4294f45ddd9",
"assets/assets/books/volume-1782038749072-page-006.jpg": "081d2cf87ee65612c84e8c20c1f86d7e",
"assets/assets/books/volume-1782038749072-page-007.jpg": "8cba603db71a9104f5705b14baad02df",
"assets/assets/books/volume-1782038749072-page-008.jpg": "5be25ef577fc6ab964b4d77f512a5724",
"assets/assets/books/volume-1782038802047-original.pdf": "1ccb13debef52d530292c1f62b8376ff",
"assets/assets/books/volume-1782038802047-page-001.jpg": "ea7209a4d0c5d2eba3753c33caf51faf",
"assets/assets/books/volume-1782038802047-page-002.jpg": "39859f61a9887ecc3bdbfc2e6138fff8",
"assets/assets/books/volume-1782038802047-page-003.jpg": "d09318bd648b918e9581f2d80ca66879",
"assets/assets/books/volume-1782038802047-page-004.jpg": "cb4b5f3dbb60da312c00a397f79e3b68",
"assets/assets/books/volume-1782038802047-page-005.jpg": "fab3aaea85cbf609e8f6a0eaf4bd796f",
"assets/assets/books/volume-1782038802047-page-006.jpg": "7d31dc3a4df5481ee5bafe59f9e5b01c",
"assets/assets/books/volume-1782038802047-page-007.jpg": "4daa788aa7143164f924c69f9b290aae",
"assets/assets/books/volume-1782038802047-page-008.jpg": "0841bb8a475c0f29b7a424efe250994c",
"assets/assets/books/volume-1782038903389-original.pdf": "c4305d6e4de77e141566ff81bcaedb75",
"assets/assets/books/volume-1782038903389-page-001.jpg": "778766da824e0944f9d428f737630003",
"assets/assets/books/volume-1782038903389-page-002.jpg": "57aeb355ab27388d3c2f4d9282f0045d",
"assets/assets/books/volume-1782038903389-page-003.jpg": "d377bf19f686410d692e0c5b979e3b9e",
"assets/assets/books/volume-1782038903389-page-004.jpg": "dece742a7630012ff28ba40fa0676b9a",
"assets/assets/books/volume-1782038903389-page-005.jpg": "964bd330e2a11de2cb803dd9bc9ef9da",
"assets/assets/books/volume-1782038903389-page-006.jpg": "091a034df80944388ac7e943be16a90a",
"assets/assets/books/volume-1782038903389-page-007.jpg": "27fabcf8a383387a65eb2fcae2ac9914",
"assets/assets/books/volume-1782038903389-page-008.jpg": "20682cfb599e3fa4e523faf351c625cf",
"assets/assets/books/volume-1782039018488-original.pdf": "a0edd5ac42ac6990c0ef56344ea796f0",
"assets/assets/books/volume-1782039018488-page-001.jpg": "5e363bfcb73581c4a8a7029a99e42273",
"assets/assets/books/volume-1782039018488-page-002.jpg": "15a528fa75ffb04227badbff0cdad040",
"assets/assets/books/volume-1782039018488-page-003.jpg": "99f4ea4335a21a3fc7945591b29c5898",
"assets/assets/books/volume-1782039018488-page-004.jpg": "12268bb6ebd54d36ceb7d80ab152e90e",
"assets/assets/books/volume-1782039018488-page-005.jpg": "c4c9045143ce3a6e78f4a559e2a9bead",
"assets/assets/books/volume-1782039018488-page-006.jpg": "0b44d06b368aecbb7e228770c2968353",
"assets/assets/books/volume-1782039018488-page-007.jpg": "bacdacf2db8c4df76807508dbfdd76ea",
"assets/assets/books/volume-1782039018488-page-008.jpg": "2861ceb5230bc006926a6032b697ee13",
"assets/assets/books/volume-1782039083201-original.pdf": "ff218f65fe6e978d14f96869ffde85cf",
"assets/assets/books/volume-1782039083201-page-001.jpg": "50f9d15fe8cef8694a7f9c8488f0cc23",
"assets/assets/books/volume-1782039083201-page-002.jpg": "37e07a5c2e7d02069ee9f2992894e46d",
"assets/assets/books/volume-1782039083201-page-003.jpg": "bafd0309a18f10fedfcc7c35e1ae558a",
"assets/assets/books/volume-1782039083201-page-004.jpg": "db377c6ae96221289615937961d7805b",
"assets/assets/books/volume-1782039083201-page-005.jpg": "20971d6a935b7d3cb6742b8d14d5d769",
"assets/assets/books/volume-1782039083201-page-006.jpg": "97597d04c695a0409b3881b22c2e5ba1",
"assets/assets/books/volume-1782039083201-page-007.jpg": "3faab80cf3a397f921ad4abfdd32e237",
"assets/assets/books/volume-1782039083201-page-008.jpg": "1c5edf8f85e9a8f019238287a9557fde",
"assets/assets/books/volume-1782039165812-original.pdf": "aea9fb0760b63dd4e6ebc1d5e5b69d91",
"assets/assets/books/volume-1782039165812-page-001.jpg": "784ca71726aa3bf950041d435d374562",
"assets/assets/books/volume-1782039165812-page-002.jpg": "a2b38a4144fb06b45b1218b682dfa317",
"assets/assets/books/volume-1782039165812-page-003.jpg": "2d2bfb9da18f38c62375a76c8abee9c8",
"assets/assets/books/volume-1782039165812-page-004.jpg": "46d30dbb72d7e7aa5d83b261b9d856fe",
"assets/assets/books/volume-1782039165812-page-005.jpg": "7d0b4bc59225ed65cdf6572d88d40f97",
"assets/assets/books/volume-1782039165812-page-006.jpg": "3d73b01833f44773ca553faf1ad9163f",
"assets/assets/books/volume-1782039165812-page-007.jpg": "fdc5dbd7a5699d06742e5e4f5cb796d5",
"assets/assets/books/volume-1782039165812-page-008.jpg": "a6ebdf7a78094c7c4dacbf599e91cd90",
"assets/assets/books/volume-1782039848947-original.pdf": "aefd401c2473d387324fd353d8a4cf5d",
"assets/assets/books/volume-1782039848947-page-001.jpg": "b0559d1b8ed9af506e1b320a8434ec90",
"assets/assets/books/volume-1782039848947-page-002.jpg": "b34f065f500c515a0b703d99f0d4017c",
"assets/assets/books/volume-1782039848947-page-003.jpg": "34d93937a7926850346876425876641c",
"assets/assets/books/volume-1782039848947-page-004.jpg": "d7f2fafb2462dfa4345d4f2c06b5a88c",
"assets/assets/books/volume-1782039848947-page-005.jpg": "8914d7d64dc216c0da0204613436be9c",
"assets/assets/books/volume-1782039848947-page-006.jpg": "ef8f87ee520c02610197e121dd5e1222",
"assets/assets/books/volume-1782039848947-page-007.jpg": "8c1c482010dd18a74153b8adbbe3d156",
"assets/assets/books/volume-1782039848947-page-008.jpg": "c5fcd72a01af7e23cb7cb5ef0f6f3ead",
"assets/assets/books/volume-1782039848947-page-009.jpg": "4d78e32e7938d00abe3d54b99a307f02",
"assets/assets/books/volume-1782039848947-page-010.jpg": "573f0618aaf0fd968c3dde6982ec6582",
"assets/assets/books/volume-1782039848947-page-011.jpg": "759d21f6bce09533d281552aaafd2186",
"assets/assets/books/volume-1782039848947-page-012.jpg": "7122dae330a2e9db76e913aa03df736b",
"assets/assets/books/volume-1782039848947-page-013.jpg": "2a217ba89372e89827bb015d26544e51",
"assets/assets/books/volume-1782039848947-page-014.jpg": "3ded18b926ca0f7344da6dce4b2caef9",
"assets/assets/books/volume-1782039848947-page-015.jpg": "611207492045ec09d16caaf96ed0c288",
"assets/assets/books/volume-1782039848947-page-016.jpg": "70b35435efd7f7ed1a8dd1662c1986f9",
"assets/assets/books/volume-1782039904524-original.pdf": "ff53b0c72b19c1bc3048c5c4bf60446d",
"assets/assets/books/volume-1782039904524-page-001.jpg": "a4c9d7f1fd5391e7dc893e925146997c",
"assets/assets/books/volume-1782039904524-page-002.jpg": "7644c7de161b1b911c52f6223f99fdde",
"assets/assets/books/volume-1782039904524-page-003.jpg": "b61134169d91e2508f7efcedf239f4af",
"assets/assets/books/volume-1782039904524-page-004.jpg": "f7c43c0042f939a68b548a7b49672a95",
"assets/assets/books/volume-1782039904524-page-005.jpg": "c886c75f7586305420a717baba7d7a09",
"assets/assets/books/volume-1782039904524-page-006.jpg": "acd7125aecf624ed9cb378e5a6904c4e",
"assets/assets/books/volume-1782039904524-page-007.jpg": "160896a0111d6e83df79533cd6bcc287",
"assets/assets/books/volume-1782039904524-page-008.jpg": "03bfc9d33a9226ee3e2e30b491ea02a9",
"assets/assets/books/volume-1782041865498-original.pdf": "aefd401c2473d387324fd353d8a4cf5d",
"assets/assets/books/volume-1782041865498-page-001.jpg": "64bbb94d4870df481c094510f9aa3c4f",
"assets/assets/books/volume-1782041865498-page-002.jpg": "314ba7934f28757eb4bb88b8d5109a97",
"assets/assets/books/volume-1782041865498-page-003.jpg": "494695c6cd9cabbf441f8a5ad95f3767",
"assets/assets/books/volume-1782041865498-page-004.jpg": "7015a0131db638ffcd1c1845f17fa201",
"assets/assets/books/volume-1782041865498-page-005.jpg": "b5dd4f18285a4ed73d6c17f38ec46e76",
"assets/assets/books/volume-1782041865498-page-006.jpg": "b305d83904f1c5bd3ed2c3c91f94f9f1",
"assets/assets/books/volume-1782041865498-page-007.jpg": "0884327af06535c120558532ff591244",
"assets/assets/books/volume-1782041865498-page-008.jpg": "0fc80115522d0dba28deabaa70727920",
"assets/assets/data/catalog.json": "4ca62818efd04eb462744832c03354a7",
"assets/assets/data/categories.json": "6df734539761f88cd476785dbf7e0606",
"assets/assets/images/heritage-cover.png": "a04fd81abdb7d413440eef6d2a7d9433",
"assets/assets/images/vijnanadeepam-logo.png": "c5d6dcf559ca844a5d119da013a81adc",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "ad65a0b96e8323caf57189c0460edc8f",
"assets/NOTICES": "6befd059354e2539021ca7f63f70e660",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"flutter_bootstrap.js": "3b0560494fea00ad6f7781669555cb92",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/vijnanadeepam-192.png": "c5d6dcf559ca844a5d119da013a81adc",
"icons/vijnanadeepam-512.png": "1c9395618cb7e41d3397538d95b8e7f4",
"icons/vijnanadeepam-logo.svg": "cd98581764412a7470f34f8bf0a33f81",
"icons/vijnanadeepam-maskable-192.png": "1dd925dc6d6d4c3297bf6e1efee39bac",
"icons/vijnanadeepam-maskable-512.png": "7a485e7558418cb0abcbabc77244da50",
"index.html": "a9cde14cbb1286621a9a0e84fbfcf123",
"/": "a9cde14cbb1286621a9a0e84fbfcf123",
"main.dart.js": "1f43de9009b12d9e5310bfad762f62da",
"manifest.json": "021b52e837402da616255c1d1eb89206",
"update-worker.js": "961797a73e96e66c4d11e7c74f16110d",
"version.json": "75a6e7e74d229681cd30ed48ef98487b",
"vijnanadeepam-favicon.png": "02352b80a28aab3b334204279017746d"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
