Smalltalk snapshot: true andQuit: true withDeferredStartup:  
    [ 
        Computer current defaultSerialPort nextPutAll: 
            'Total, ', Computer current processor rdtsc asString, String crlf.
    ].
