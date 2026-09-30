const CACHE='material-shortage-v3';
const ASSETS=['./','./index.html','./styles.css','./app.js','./manifest.webmanifest','./icon.svg','./seed-materials.js','./vendor/xlsx.full.min.js','./vendor/jszip.min.js'];
self.addEventListener('install',event=>{
 event.waitUntil(caches.open(CACHE).then(cache=>cache.addAll(ASSETS)).then(()=>self.skipWaiting()));
});
self.addEventListener('activate',event=>{
 event.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(key=>key!==CACHE).map(key=>caches.delete(key)))).then(()=>self.clients.claim()));
});
self.addEventListener('fetch',event=>{
 if(event.request.method!=='GET')return;
 event.respondWith((async()=>{
  const cached=await caches.match(event.request);if(cached)return cached;
  try{
   const response=await fetch(event.request);
   if(response&&response.status===200){const copy=response.clone();const cache=await caches.open(CACHE);cache.put(event.request,copy);}
   return response;
  }catch(error){return caches.match('./index.html');}
 })());
});