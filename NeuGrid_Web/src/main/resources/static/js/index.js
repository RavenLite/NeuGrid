new Vue({
    el: '#app',
    data: {
        gridData1: [],
        gridData2: [],
        apiUrl1: 'http://localhost:8080/getNodeSet',
        apiUrl2: 'http://localhost:8080/getAdjMatrix'
    },
    mounted: function () {
        this.getNodeSet(),
        this.getMatrix()
    },
    methods: {
        getNodeSet(){
            this.$http.get(this.apiUrl1).then((response) => {
                console.log(response),
                
                this.gridData1 = response.body,
                console.log(this.gridData1)
            })
        },
        getMatrix(){
            this.$http.get(this.apiUrl2).then((response) => {
                console.log(response),
                
                this.gridData2 = response.body,
                console.log(this.gridData2)
            });
        }
    }
});