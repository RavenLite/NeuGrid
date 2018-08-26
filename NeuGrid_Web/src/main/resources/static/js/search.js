new Vue({
    el: '#app1',
    data: {
        gridData: [],
        apiUrl1: 'http://localhost:8080/api/getAllClients',
        apiUrl2: 'http://localhost:8080/api/getClientByClientID',
        apiUrl3: 'http://localhost:8080/api/getTotalPaidFeeByClient_ID',
        apiUrl4: 'http://localhost:8080/api/getCostsByClient_ID',
        client_id: '',
        client_name: '',
        address: '',
        balance: '',
        total_fee: '',
        gridData2: []
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
        select(index){
            console.log(index);
            this.client_id = this.gridData[index-1].client_id;
            console.log(this.client_id);
            this.getSomeoneInfo();
        },
        getSomeoneInfo(){
            console.log("*"+ this.client_id);
            this.$http.get(this.apiUrl2,{params: {client_id: this.client_id}}).then((response) => {
                console.log(response),
                this.client_id = response.body.data.client_id,
                this.client_name = response.body.data.client_name,
                this.address = response.body.data.address,
                this.balance = response.body.data.balance
            });
            this.$http.get(this.apiUrl3,{params: {client_id: this.client_id}}).then((response) => {
                console.log(response),
                this.total_fee = response.body.data.total_fee
            });
            this.$http.get(this.apiUrl4,{params: {client_id: this.client_id}}).then((response) => {
                console.log(response),
                this.gridData2 = response.body.data
            });
        }
    }
});