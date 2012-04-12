$(window).bind("load", function()
$('#myController').jflow({
    controller: ".jFlowControl", // must be class, use . sign
    slideWrapper : "#jFlowSlider", // must be id, use # sign
    slides: "#mySlides",  // the div where all your sliding divs are nested in
    selectedWrapper: "jFlowSelected",  // just pure text, no sign
    width: "800px",  // this is the width for the content-slider
    height: "500px",  // this is the height for the content-slider
    duration: 400,  // time in miliseconds to transition one slide
    prev: ".jFlowPrev", // must be class, use . sign
    next: ".jFlowNext", // must be class, use . sign
    auto: true
});
});