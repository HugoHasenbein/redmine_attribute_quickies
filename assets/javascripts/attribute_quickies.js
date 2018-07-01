function attributeQuickiesForm(url, form) {
  if(form.value=='') 
  	return;
  $.ajax({
    url: url,
    type: 'post',
    data: $(form).serialize()
  });
}
