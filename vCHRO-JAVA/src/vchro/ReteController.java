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
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import jess.Deffacts;
import jess.Deftemplate;
import jess.Fact;
import jess.JessException;
import jess.RU;
import jess.Rete;
import jess.Value;


public class ReteController {
    public Rete engine;
    private List<ReteControllerEventListener> listeners;
    private Map<String, String> mapScale; //for each ident allowable input MIN,MAX,STEP
    public static final int INT_MODE_CTO = 1;
    public static final int INT_MODE_CEO = 2;
    public int interviewMode;
    private String idealEmpConceptFile;
    
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
        
        interviewMode = INT_MODE_CTO;
        idealEmpConceptFile = "idealEmployeeConcept.clp";
    }
    
    public void addListener(ReteControllerEventListener listener){
        listeners.add(listener);
        Logger.getLogger(ReteController.class.getName()).log(Level.INFO, "Adding Listener "+listener.getClass().getName());
    }
    
    public void loadClipFile(String clipScriptFilePath){
//        FileReader reader = null;
//        String command = "";
//        try {
//            URL fileUrl = getClass().getResource(clipScriptFilePath);
//            File file = new File(fileUrl.toURI());
//            if (file.exists()) {
//                reader = new FileReader(file);
//                int i = 0;
//                while (i != -1) {
//                    i = reader.read();
//                    command += (char) i;
//                }
//            }else {//let listeners know that file not found and act accordingly
//                for(ReteControllerEventListener l : listeners){
//                    l.clipFileError("File not found");
//                }
//                return;
//            }
//        } catch (URISyntaxException | FileNotFoundException ex) {
//            Logger.getLogger(ReteController.class.getName()).log(Level.SEVERE, null, ex);
//            for(ReteControllerEventListener l : listeners){
//                l.clipFileError(ex.getMessage());
//            }
//        } catch (IOException ex) {
//            Logger.getLogger(ReteController.class.getName()).log(Level.SEVERE, null, ex);
//            for(ReteControllerEventListener l : listeners){
//                l.clipFileError(ex.getMessage());
//            }
//            
//        } finally {
//            if (reader != null) {
//                try {
//                    reader.close();
//                } catch (IOException ex) {
//                    for(ReteControllerEventListener l : listeners){
//                        l.clipFileError(ex.getMessage());
//                    }
//                    Logger.getLogger(ReteController.class.getName()).log(Level.SEVERE, null, ex);
//                }
//            }
//        }
        
        try{
            engine.clear();
            if(engine.batch(clipScriptFilePath).toString().equalsIgnoreCase("TRUE")){
                engine.reset();
//                Fact factIdealEmp = new Fact(engine.findDeftemplate("idealEmployee"));
//                factIdealEmp.setSlotValue("trust", new Value(4.0, RU.FLOAT));
//                factIdealEmp.setSlotValue("neuro", new Value(3.5, RU.FLOAT));
//                factIdealEmp.setSlotValue("consci", new Value(3.0, RU.FLOAT));
//                factIdealEmp.setSlotValue("extro", new Value(2.5, RU.FLOAT));
//                factIdealEmp.setSlotValue("agree", new Value(2.0, RU.FLOAT));
//                factIdealEmp.setSlotValue("coach", new Value(4.0, RU.FLOAT));
                engine.batch(idealEmpConceptFile);
                ArrayList<Object> facts = GetAllFacts();
                for(int i= 0 ;i< facts.size();i++){
                    System.out.println(facts.get(i).toString());
                }
                for(ReteControllerEventListener l : listeners){
                        l.clipFileLoaded();
                }
            }
            
        }catch(JessException ex){
           for(ReteControllerEventListener l : listeners){
                l.clipFileError("Engine failed to load/execute the file! Error: "+ex.getMessage());
            }
        }
        //engine.eval(command);
        
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
    
    public ArrayList<Object> GetAllFacts() {
        Iterator list = engine.listFacts();
        ArrayList<Object> facts = new ArrayList<Object>();
        while (list.hasNext()) {
            facts.add(list.next());
        }
        return facts;
    }
    
    public String GetResult() {
        ArrayList<Object> facts = GetAllFacts();
        String advice = "";
        for(int i= 0 ;i< facts.size();i++){
            String name = facts.get(i).toString();
            if(name.contains("poorByCEO")){
                return "No";
            }else if(name.contains("goodByCEO")){
                return "Yes/May be";
            }else if(name.contains("exceptional")){
                return "Yes";
            }else if(name.contains("disqualified")){
                return "Disqualified";
            }
        }
        return advice;
    }
    
    //on an assert statment, run the engine, if any rule fires, check if disqualified return false else return true
    public boolean isDisqualified(String assertThisAnswer) throws JessException{
        //System.out.println("Asserting# "+assertThisAnswer);
        engine.eval(assertThisAnswer);
        if(engine.run() > 0){
            ArrayList<Object> facts = GetAllFacts();
            for(int i= 0 ;i< facts.size();i++){
                String name = facts.get(i).toString();
                //System.out.println(name);
                if(name.contains("disqualified")){
                    System.out.println("Candidate is disqualified!!");
                    return true;
                }
            }
        }
        return false;
    }
    
    public boolean isEligbileForCEOInterview(){
        ArrayList<Object> facts = GetAllFacts();
        for(int i= 0 ;i< facts.size();i++){
            String name = facts.get(i).toString();
            if(name.contains("canAskCEO")){
                this.interviewMode = INT_MODE_CEO;
                return true;
            }
        }
        return false;
    }
    
    public int getCurrentInterviewMode(){
        return this.interviewMode;
    }
    
    public void setCurrentInterviewMode(int intMode){
        this.interviewMode = intMode;
    }
    
}
