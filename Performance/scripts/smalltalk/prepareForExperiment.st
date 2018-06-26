Smalltalk snapshot: true andQuit: true withDeferredStartup:  
    [ 
        "Neeeded because is also run before startup"
        Computer isSqueakNOS ifTrue: [
            Harness new run: {nil. 'DeltaBlue'. 10. 100.}. 
        ].
    ].
