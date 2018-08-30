new Vue({
    el: '#app',
    data: {
        gridData: [],
        apiUrl: 'http://localhost:8080/api/read',
        client_id: '',
        money: '',
        bank_id: '',
        device_id:'',
        state:''
    },
    methods: {
        submit(){
            console.log(this.client_id);
            console.log(this.money);
            console.log(this.bank_id);
            console.log(this.device_id);
            this.$http.get(this.apiUrl,{params: {client_id: this.client_id, money: this.money, bank_id: this.bank_id, device_id: this.device_id}}).then((response) => {
                console.log(response);
                this.state = response.body.data.state;
                console.log("state:" + this.state);
            });
            alert(this.state);
        }
    }
});