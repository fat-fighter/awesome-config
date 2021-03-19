local newdecoder = require 'modules.lunajson.decoder'
local newencoder = require 'modules.lunajson.encoder'
local sax = require 'modules.lunajson.sax'
-- If you need multiple contexts of decoder and/or encoder,
-- you can require lunajson.decoder and/or lunajson.encoder directly.
return {
	decode = newdecoder(),
	encode = newencoder(),
	newparser = sax.newparser,
	newfileparser = sax.newfileparser,
}
