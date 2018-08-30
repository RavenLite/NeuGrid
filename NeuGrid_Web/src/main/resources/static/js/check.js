new Vue({
    el: '#app',
    data: {
        gridData: [],
        apiUrl1: 'http://localhost:8080/api/check_total',
        apiUrl2: 'http://localhost:8080/api/check_detail',
        bank_id_1: 'bank_id_1',
        count: 'count',
        money: 'money',
        read_date_1: 'read_date_1',
        bank_id_2: 'bank_id_2',
        read_date_2: 'read_date_2',
        state:''
    },
    methods: {
        submit1(){
            console.log(this.transfer_id);
            this.$http.get(this.apiUrl1,{params: {bank_id_1: this.bank_id_1, count: this.count, money: this.money, read_date_1: "20180820"}}).then((response) => {
                console.log(response);
                this.state = response.body.data.state;
                console.log("state:" + this.state);
            });
            alert(this.state);
        },
        submit2(){
            console.log(this.transfer_id);
            this.$http.get(this.apiUrl2,{params: {bank_id_2: this.bank_id_2, read_date_2: "20180820"}}).then((response) => {
                console.log(response);
                this.state = response.body.data.state;
                console.log("state:" + this.state);
            });
            alert(this.state);
        }
    }
});