new Vue({
    el: '#app',
    data: {
        gridData: [],
        apiUrl: 'http://localhost:8080/api/getAllClients',
    },
    mounted: function () {
        this.getAllClients()
    },
    methods: {
        getAllClients(){
            console.log("Requesting");
            this.$http.post(this.apiUrl).then((response) => {
                console.log(response),
                this.gridData = response.body
            })
        }
    }
});