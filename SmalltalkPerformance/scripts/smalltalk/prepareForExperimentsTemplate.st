Smalltalk snapshot: true andQuit: true withDeferredStartup:  
    [ 
        "Neeeded because is also run before startup"
        Computer isSqueakNOS ifTrue: [
            Computer current defaultSerialPort isNil ifTrue: [^self].
            Harness new run: {nil. 'EXPERIMENT'. ITERATIONSOUTER. ITERATIONSINNER.}. 
            Computer current defaultSerialPort nextPutAll: 'FINISHHHHH'
        ].
    ].