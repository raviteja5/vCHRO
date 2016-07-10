/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vchro;

import java.io.File;
import java.io.FileNotFoundException;
import java.math.BigDecimal;
import java.util.Scanner;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author mamun028
 */
public class IdealEmployeeModel {

    private double trust;
    private double neuro;
    private double consci;
    private double extro;
    private double agree;
    private double coach;
    public IdealEmployeeModel() throws Exception{
        String idealFileName = "idealEmployeeConcept.clp";
        Pattern p = Pattern.compile("\\(((trust|neuro|consci|extro|agree|coach)\\s*[0-5]\\.[0-9]{1,2}?)\\)");
        
        StringBuilder result = new StringBuilder("");

	File file = new File(idealFileName);
        Scanner scanner = new Scanner(file);
        while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                //System.out.println(assertPattern.toString() + " match from Line:: "+line + " :: Matches? : "+line.matches("\\d+(\\.\\d+)?"));
                Matcher m = p.matcher(line);
                while(m.find()) {
                    StringTokenizer strTok = new StringTokenizer(m.group(1));
                    //System.out.println(m.group(1));
                    while(strTok.hasMoreTokens()){
                        String nextToken = strTok.nextToken();
                        if(nextToken.equalsIgnoreCase("trust")){
                            this.trust = Double.parseDouble(strTok.nextToken());
                        }else if(nextToken.equalsIgnoreCase("coach")){
                            this.coach = Double.parseDouble(strTok.nextToken());
                        }else if(nextToken.equalsIgnoreCase("neuro")){
                            this.neuro = Double.parseDouble(strTok.nextToken());
                        }else if(nextToken.equalsIgnoreCase("consci")){
                            this.consci = Double.parseDouble(strTok.nextToken());
                        }else if(nextToken.equalsIgnoreCase("extro")){
                            this.extro = Double.parseDouble(strTok.nextToken());
                        }else if(nextToken.equalsIgnoreCase("agree")){
                            this.agree = Double.parseDouble(strTok.nextToken());
                        }
                    }
                }
                
                result.append(line).append("\n");
        }
        System.out.println(result);
        scanner.close();
    }
    
//    public static void main(String args[]) throws FileNotFoundException{
//        System.out.println(new IdealEmployeeModel());
//
//    }
    
    @Override
    public String toString(){
        return "(assert (idealEmployee (trust "+new BigDecimal(this.trust).setScale(3, BigDecimal.ROUND_HALF_UP).doubleValue()
                +") (neuro "+new BigDecimal(this.neuro).setScale(3, BigDecimal.ROUND_HALF_UP).doubleValue()
                +") (consci "+new BigDecimal(this.consci).setScale(3, BigDecimal.ROUND_HALF_UP).doubleValue()
                +") (extro "+new BigDecimal(this.extro).setScale(3, BigDecimal.ROUND_HALF_UP).doubleValue()
                +") (agree "+new BigDecimal(this.agree).setScale(3, BigDecimal.ROUND_HALF_UP).doubleValue()
                +") (coach "+new BigDecimal(this.coach).setScale(3, BigDecimal.ROUND_HALF_UP).doubleValue()
                +")))";
    }
    
    public void setTrust(double trust) {
        this.trust = trust;
    }

    public void setNeuro(double neuro) {
        this.neuro = neuro;
    }

    public void setConsci(double consci) {
        this.consci = consci;
    }

    public void setExtro(double extro) {
        this.extro = extro;
    }

    public void setAgree(double agree) {
        this.agree = agree;
    }

    public void setCoach(double coach) {
        this.coach = coach;
    }

    public double getTrust() {
        return trust;
    }

    public double getNeuro() {
        return neuro;
    }

    public double getConsci() {
        return consci;
    }

    public double getExtro() {
        return extro;
    }

    public double getAgree() {
        return agree;
    }

    public double getCoach() {
        return coach;
    }
}
