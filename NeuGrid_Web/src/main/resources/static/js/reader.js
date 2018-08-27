new Vue({
    el: '#app',
    data: {
        gridData: [],
        apiUrl1: 'http://localhost:8080/api/getAllReaders',
        apiUrl2: 'http://localhost:8080/api/addReader',
        reader_id: '',
        reader_name: ''
    },
    mounted: function () {
        this.getAllReaders()
    },
    methods: {
        getAllReaders(){
            console.log("Requesting");
            this.$http.post(this.apiUrl1).then((response) => {
                console.log(response),
                this.gridData = response.body.data
            })
        },
        submit(){
            console.log(this.reader_id);
            this.$http.get(this.apiUrl2,{params: {reader_id: this.reader_id, reader_name: this.reader_name}}).then((response) => {
                console.log(response);
            });
            this.getAllReaders();
        }
    }
});