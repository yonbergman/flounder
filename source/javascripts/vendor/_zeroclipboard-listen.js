jQuery(document).ready(function($) {
    $("body")
        .on("copy", ".zclip", function(/* ClipboardEvent */ e) {
            e.clipboardData.clearData();
            e.clipboardData.setData("text/plain", $(this).data("zclip-text"));
            e.preventDefault();
        });
});