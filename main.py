import clips
clips.Load("vchro.clp")
clips.Reset()
clips.Run()
s = clips.StdoutStream.Read()
print s
#clips.PrintFacts()
