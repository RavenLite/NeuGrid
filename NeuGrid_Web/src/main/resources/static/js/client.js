new Vue({
    el: '#app',
    data: {
        gridData: [],
        apiUrl1: 'http://localhost:8080/api/getAllClients',
        apiUrl2: 'http://localhost:8080/api/addClient',
        client_id: '',
        client_name: '',
        address: ''
    },
    mounted: function () {
        this.getAllClients()
    },
    methods: {
        getAllClients(){
            console.log("Requesting");
            this.$http.post(this.apiUrl1).then((response) => {
                console.log(response),
                this.gridData = response.body.data
            })
        },
        submit(){
            console.log(this.client_id);
            this.$http.get(this.apiUrl2,{params: {client_id: this.client_id, client_name: this.client_name, address: this.address}}).then((response) => {
                console.log(response);
            });
            this.getAllClients();
        }
    }
});