$.unblockUI();
$('.images-list #img_<%=@image.id%>').remove();
$('.images-list').append('<%= escape_javascript(render :partial => "image.haml") %>');
