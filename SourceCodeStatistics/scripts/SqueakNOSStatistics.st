(RPackageOrganizer default packageNamed: 'SqueakNOS') classTags do: 
	[:classTag | 
		((RPackageOrganizer default packageNamed: 'SqueakNOS') classTagNamed: classTag name) classes do:
			[: klass | | loc |
				Stdio stdout nextPutAll: 'CogNOS,', classTag name asString, ',Smalltalk, ', klass name asString, ',' ,
					klass selectors size printString.
				loc := 0.
				klass selectors do: [ :selector | 
					loc := loc + (klass methodNamed: selector) linesOfCode.
				].
				Stdio stdout nextPutAll: ',', loc printString, String crlf.
			]
	].

Smalltalk snapshot: false andQuit: true    