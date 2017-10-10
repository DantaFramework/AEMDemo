(function ($, $document) {
    "use strict";

    function previewimg()
    {
        var previewimgList = $('[data-previewimg="true"]');

        if (previewimgList.length)
        {
            previewimgList.each(function(){
                var $this = $(this);
                var input = $('>.coral-InputGroup>input', $this);
                var $assetpickerPreviewImg = $this.parent().find('.asset-picker-image-preview');
                var imgPath;
                if (input.length) {
                    imgPath = input.val();
                }
                if (imgPath && !$assetpickerPreviewImg.length) {
                    imgPrevDiv(imgPath, $this);
                }
                var readonly = $this.parent().prev('.foundation-field-readonly');
                if (readonly.length) {
                    var readOnlyImg = readonly.find('.coral-Form-field');
                    if (!readOnlyImg.find('img').length) {
                        readOnlyImg.html(imgTag(readOnlyImg.html()));
                    }
                }
            });
        }
    }

    function imgPrevDiv(imgPath, sibling) {
        var imgContainer = sibling.parent().find('.image-preview');
        if (imgContainer.length) {
            var img = imgContainer.find('>img');
            img.attr('src', imgPath);
            img.attr('alt', imgPath);
            img.attr('title', imgPath);
            img.attr('style', 'width:250px');
        }
        else {
            var imgPrev = [];
            imgPrev.push("<div class=\"image-preview\">");
            imgPrev.push("<label class='coral-Form-fieldlabel'>Image Preview: &nbsp;</label>");
            imgPrev.push(imgTag(imgPath));
            sibling.after(imgPrev.join(''));
        }
    }

    function imgTag(src) {
        var rendition = src;
        if (src.indexOf("/content/dam") !== -1){
            rendition = src + "/_jcr_content/renditions/cq5dam.thumbnail.319.319.png"
            return '<img src="'+rendition+'" alt="'+src+'" title="'+src+'" /></div>';
        }
        return '<img src="'+rendition+'" alt="'+src+'" title="'+src+'" style="width:250px;" /></div>';
    }

    $document.ready(function(){
        setTimeout(previewimg, 101);
    });

    $document.on("dialog-ready", function() {
        setTimeout(previewimg, 101);
    });

    $document.on("change", function() {
        setTimeout(previewimg, 101);
    });

})($, $(document));