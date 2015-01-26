<body>

<script>
    function myFunc() {
        var resultHTML = "";
        $.ajax({
            type: "POST",
            url: "test.jsp",
            data: {name: "test", streamName: "test"},
            error: function (a, b, c) {
                //  alert(a+"  "+b+" "+c);


            },
            success: function (s) {
                $val = s.toString();
                alert(s);

                var reg = /\<p[^>]*\>([^]*)\<\/p/m;
                var result = $val.match( reg )[1];
                console.log(result);
                var parser = new DOMParser();
                var doc = parser.parseFromString(result,"text/xml");
                console.log(doc);

//                console.log(s);
                //          CARBON.showInfoDialog("script successfully saved into registry");
            }
        });


//        var parser = new DOMParser();
//        var doc = parser.parseFromString(resultHTML,"text/xml");
//        console.log(doc);
    }




</script>

<button onclick="myFunc()">test</button>
</body>

<script>




</script>