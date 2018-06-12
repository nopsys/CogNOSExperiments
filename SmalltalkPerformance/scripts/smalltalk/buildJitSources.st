[
	VMMaker generateSqueakSpurCog64VM.
	VMMaker generateVMPlugins.
]	
on: ProvideAnswerNotification do: [:ex | 
	ex resume: true
].

Smalltalk snapshot: false andQuit: true
