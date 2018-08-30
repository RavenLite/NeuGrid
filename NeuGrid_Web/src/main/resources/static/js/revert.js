new Vue({
    el: '#app',
    data: {
        gridData: [],
        apiUrl: 'http://localhost:8080/api/revert',
        transfer_id: '',
        state:''
    },
    methods: {
        submit(){
            console.log(this.transfer_id);
            this.$http.get(this.apiUrl,{params: {transfer_id: this.transfer_id}}).then((response) => {
                console.log(response);
                this.state = response.body.data.state;
                console.log("state:" + this.state);
            });
            alert(this.state);
        }
    }
});