new Vue({
    el: '#app',
    data: {
        gridData: [],
        apiUrl1: 'http://localhost:8080/api/getAllBanks',
        apiUrl2: 'http://localhost:8080/api/addBank',
        bank_id: '',
        bank_name: ''
    },
    mounted: function () {
        this.getAllBanks()
    },
    methods: {
        getAllBanks(){
            console.log("Requesting");
            this.$http.post(this.apiUrl1).then((response) => {
                console.log(response),
                this.gridData = response.body.data
            })
        },
        submit(){
            console.log(this.reader_id);
            this.$http.get(this.apiUrl2,{params: {bank_id: this.bank_id, bank_name: this.bank_name}}).then((response) => {
                console.log(response);
            });
            this.getAllBanks();
        }
    }
});