emojimap = [
  [':D' ,"🤣", "rotfl.png"],
  [':o' ,"😯", "surprised.png"],
  [":'(","😢", "crying.png"],
  ["<3" ,"❤️", "heart.png"],
  [":(" ,"😠", "angry.png"],
]

function spawnEmoji(code) {
  var i = rand(0, emojimap.length-1)
  if (code) {
    emojimap.forEach( function(entry, j) {
      if (entry[0] == code) i = j
    })
  }
  dispatchEmoji(emojimap[i][1], emojimap[i][2])
}

function dispatchEmoji(text, src) {
  var canvas = document.getElementById('emoji_canvas');
  var emoji = document.createElement("img");
  emoji.setAttribute("src", src)
  emoji.setAttribute("alt", text)
  emoji.setAttribute("class", "emoji")
  var durationString = rand(2,4) +"s," + rand(4,8) +"s"
  emoji.style.animationDuration = durationString;
  emoji.style.marginLeft = 2+rand(85,95) + 'vw'
  emoji.addEventListener("animationend",function(){canvas.removeChild(emoji)}, false, false, 'bottom');
  canvas.appendChild(emoji);
}

function rand (min, max) {
	return Math.floor(Math.random() * (max - min + 1)) + min;
}