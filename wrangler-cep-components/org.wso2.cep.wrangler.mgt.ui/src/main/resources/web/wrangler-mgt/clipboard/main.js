// main.js
var client = new ZeroClipboard( document.getElementById("copyToClipboardBtn") );

client.on( "ready", function( readyEvent ) {
    // alert( "ZeroClipboard SWF is ready!" );

    client.on( "aftercopy", function( event ) {

        CARBON.showInfoDialog("Copied definition to clipboard")
    } );
} );