function alertPreview() {
   if (document.domain != "blog.kdecherf.com") {
      $('body').append(
         $('<div />').addClass('preview').addClass('alert-msg').html('<strong>Caution:</strong> you are viewing a preview of the blog, don\'t use these links on social networks')      
      );
   }
}

$.domReady(function(){
   alertPreview();
});
