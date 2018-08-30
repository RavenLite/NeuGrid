new Vue({
    el: '#app',
    data: {
        gridData: [],
        apiUrl: 'http://localhost:8080/api/read',
        read_date: '',
        device_id: '',
        read_number: '',
        reader_id:'',
        state:''
    },
    methods: {
        submit(){
            console.log(this.read_date);
            console.log(this.device_id);
            console.log(this.read_number);
            console.log(this.reader_id);
            this.$http.get(this.apiUrl,{params: {read_date: "20180828", device_id: this.device_id, read_number: this.read_number, reader_id: this.reader_id}}).then((response) => {
                console.log(response);
                this.state = response.body.data.state;
                console.log("state:" + this.state);
            });
            alert(this.state);
        }
    }
});