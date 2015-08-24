export default function routesGen() {
this.get('/actions', 'actions');
this.get('/actions/:id', 'actions');
this.post('/actions', 'actions');
this.put('/actions/:id', 'actions');
this.del('/actions/:id', 'actions');


this.get('/copyActions', 'copy-actions');
this.get('/copyActions/:id', 'copy-actions');
this.post('/copyActions', 'copy-actions');
this.put('/copyActions/:id', 'copy-actions');
this.del('/copyActions/:id', 'copy-actions');


this.get('/deleteActions', 'delete-actions');
this.get('/deleteActions/:id', 'delete-actions');
this.post('/deleteActions', 'delete-actions');
this.put('/deleteActions/:id', 'delete-actions');
this.del('/deleteActions/:id', 'delete-actions');


this.get('/findReplaceActions', 'find-replace-actions');
this.get('/findReplaceActions/:id', 'find-replace-actions');
this.post('/findReplaceActions', 'find-replace-actions');
this.put('/findReplaceActions/:id', 'find-replace-actions');
this.del('/findReplaceActions/:id', 'find-replace-actions');


this.get('/moveActions', 'move-actions');
this.get('/moveActions/:id', 'move-actions');
this.post('/moveActions', 'move-actions');
this.put('/moveActions/:id', 'move-actions');
this.del('/moveActions/:id', 'move-actions');


this.get('/steps', 'steps');
this.get('/steps/:id', 'steps');
this.post('/steps', 'steps');
this.put('/steps/:id', 'steps');
this.del('/steps/:id', 'steps');


this.get('/tutorials', 'tutorials');
this.get('/tutorials/:id', 'tutorials');
this.post('/tutorials', 'tutorials');
this.put('/tutorials/:id', 'tutorials');
this.del('/tutorials/:id', 'tutorials');


}