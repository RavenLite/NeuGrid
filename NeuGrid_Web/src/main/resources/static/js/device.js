new Vue({
    el: '#app',
    data: {
        gridData: [],
        apiUrl1: 'http://localhost:8080/api/getAllDevices',
        apiUrl2: 'http://localhost:8080/api/addDevice',
        device_id: '',
        client_id: '',
        device_type: ''
    },
    mounted: function () {
        this.getAllDevices()
    },
    methods: {
        getAllDevices(){
            console.log("Requesting");
            this.$http.post(this.apiUrl1).then((response) => {
                console.log(response),
                this.gridData = response.body.data
            })
        },
        submit(){
            console.log(this.device_id);
            this.$http.get(this.apiUrl2,{params: {device_id: this.device_id, client_id: this.client_id, device_type: this.device_type}}).then((response) => {
                console.log(response);
            });
            this.getAllDevices();
        }
    }
});