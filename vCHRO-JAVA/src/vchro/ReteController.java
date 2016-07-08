/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 * use this link to download JESS: http://depts.washington.edu/cssuwb/m/installing_jess
 */
package vchro;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import jess.JessException;
import jess.Rete;


public class ReteController {
    public Rete engine;
    private List<ReteControllerEventListener> listeners;
    private Map<String, String> mapScale; //for each ident allowable input MIN,MAX,STEP
    
    public ReteController(){
        Logger.getLogger(ReteController.class.getName()).log(Level.INFO, "Creating Object");
        if(engine==null){
            engine = new Rete();
            listeners = new ArrayList<ReteControllerEventListener>();
        }
        mapScale = new HashMap<String, String>();
        mapScale.put("resumecontent", "0,5,1"); //On a scale of 0~5 how do you rate the candidate's resume content (0-5)
        mapScale.put("workingvisa", "0,1,1");//Enter 0 or 1 if the candidate need working VISA (0 means no, 1 means yes):
        mapScale.put("schoolrating", "0,5,1");//On a scale of 0~5 how do you rate the candidate's school rating (0-5)?
        mapScale.put("relatedworkexperience", "0,7,1");//On a scale of 0~7 how do you rate the candidate's related work experience, note that any score greater and equal to 5 means the candidate has plenty of related work experiences (0-7)?
        mapScale.put("compensation", "0,5,1");
        mapScale.put("codingconvention", "0,5,1");
        mapScale.put("codingtalent", "-5,5,1");
        mapScale.put("previouscompanyrating", "0,5,1");
        mapScale.put("codingsolution", "0,7,1");
        mapScale.put("explanation", "0,5,1");
        mapScale.put("resumerequirement", "0,1,1");
        mapScale.put("jobexperience", "0,1,1");
        mapScale.put("questionsquality", "0,5,1");
        
        mapScale.put("trustworthyness", "0,5,1");
        mapScale.put("neuroticism", "0,5,1");
        mapScale.put("conscientiousness", "0,5,1");
        mapScale.put("extrovertedness", "0,5,1");
        mapScale.put("agreeableness", "0,5,1");
        mapScale.put("coachability", "0,5,1");
    }
    
    public void addListener(ReteControllerEventListener listener){
        listeners.add(listener);
        Logger.getLogger(ReteController.class.getName()).log(Level.INFO, "Adding Listener "+listener.getClass().getName());
    }
    
    public void loadClipFile(String clipScriptFilePath) throws JessException{
        FileReader reader = null;
        String command = "";
        try {
            URL fileUrl = getClass().getResource(clipScriptFilePath);
            File file = new File(fileUrl.toURI());
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
                return;
            }
        } catch (URISyntaxException | FileNotFoundException ex) {
            Logger.getLogger(ReteController.class.getName()).log(Level.SEVERE, null, ex);
            for(ReteControllerEventListener l : listeners){
                l.clipFileError(ex.getMessage());
            }
        } catch (IOException ex) {
            Logger.getLogger(ReteController.class.getName()).log(Level.SEVERE, null, ex);
            for(ReteControllerEventListener l : listeners){
                l.clipFileError(ex.getMessage());
            }
            
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
        engine.clear();
        engine.eval(command);
        engine.reset();
        for(ReteControllerEventListener l : listeners){
                l.clipFileLoaded();
        }
    }   
    
    public int getRatingScaleMax(String ident){
        return Integer.parseInt(this.mapScale.get(ident).split(",")[1]);
    }
    
    public int getRatingScaleMin(String ident){
        return Integer.parseInt(this.mapScale.get(ident).split(",")[0]);
    }
    
    public int getRatingScaleStep(String ident){
        return Integer.parseInt(this.mapScale.get(ident).split(",")[2]);
    }
}
