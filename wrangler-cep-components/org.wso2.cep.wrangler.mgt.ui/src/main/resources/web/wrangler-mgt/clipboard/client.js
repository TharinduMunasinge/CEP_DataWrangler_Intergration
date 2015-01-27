
$(document).ready( function(){

var client = new ZeroClipboard( document.getElementById("copyBtn"), {
    moviePath: "ZeroClipboard.swf"
} );

client.on( "load", function(client) {
    // alert( "movie is loaded" );

    client.on( "complete", function(client, args) {
        client.setText(args.text);
        $('targetCopyText').fadeIn();
    } );
} );

}
);