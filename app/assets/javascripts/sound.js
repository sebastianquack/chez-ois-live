var snd;

function readme(txt, callback) {
	if(!sound_on) {
		return;
	}

	var url = 'http://momi.invisibleplayground.com/test/echo_translate_tts.php?words='+txt;
	snd = new Audio(url);
	snd.play();

	snd.addEventListener("ended", callback);
}

var reading_queue = [];

// read aloud without reading to things at the same time
function read_with_queue(speech_output) {

		// has there been audio?
		if(!snd) {
			readme(speech_output, read_next); // read now
		} else {
			// is the audio playing right now?		
			if(!snd.paused) {
				reading_queue.push(speech_output); // just put in the queue
			// is the audio currently off?
			} else {
				readme(speech_output, read_next); // read now
			}
		}
}

function read_next() {
	if(reading_queue.length > 0) {
		readme(reading_queue.shift(), read_next); // read until there is no more
	}
}
			
