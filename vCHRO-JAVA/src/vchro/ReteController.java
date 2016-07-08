/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vchro;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jess.JessException;
import jess.Rete;


public class ReteController {
    public Rete engine;
    private List<ReteControllerEventListener> listeners;
    
    public ReteController(String clipScriptFilePath){
        Logger.getLogger(ReteController.class.getName()).log(Level.INFO, "Creating Object");
        try {
            if(engine==null){
                engine = new Rete();
                listeners = new ArrayList<ReteControllerEventListener>();
            }
            FileReader reader = null;
            String command = "";
            try {
                File file = new File(clipScriptFilePath);
                if (file.exists()) {
                    reader = new FileReader(file);
                    int i = 0;
                    while (i != -1) {
                        i = reader.read();
                        command += (char) i;
                    }
                }else {//let listeners know that file not found and act accordingly
                    for(ReteControllerEventListener l : listeners){
                        l.clipFileError("File not found");
                    }
                }
            } catch (IOException ex) {
                for(ReteControllerEventListener l : listeners){
                    l.clipFileError(ex.getMessage());
                }
                Logger.getLogger(ReteController.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                if (reader != null) {
                    try {
                        reader.close();
                    } catch (IOException ex) {
                        for(ReteControllerEventListener l : listeners){
                            l.clipFileError(ex.getMessage());
                        }
                        Logger.getLogger(ReteController.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            }
            engine.executeCommand(command);
            engine.reset();
        } catch (JessException ex) {
            for(ReteControllerEventListener l : listeners){
                l.clipFileError(ex.getMessage());
            }
            Logger.getLogger(ReteController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void addListener(ReteControllerEventListener listener){
        listeners.add(listener);
        Logger.getLogger(ReteController.class.getName()).log(Level.INFO, "Adding Listener "+listener.getClass().getName());
    }
    
}
