/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication1.packpack;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

/**
 *
 * @author belikov
 */
public class HomeWork {
    
    public int CountWord(String[] ar){
        int cnt = 0;
        for (String s : ar) {
            if (s.length() <= 5 || s.length() >= 3) {
                cnt = cnt + 1;  
           } 
        }
        if (cnt % 2 == 0) {
            return cnt;
        } else 
            return cnt - 1;
                
    };
    
    
    public void ReadFile() {
    BufferedReader br = null;
        try {
            br = new BufferedReader(new FileReader("D:\\new 2.csv"));
            String tmp = "";
            int cnt;
            while ((tmp = br.readLine()) != null) {
                String[] s = tmp.split("\\s");
                int cntDiv =  CountWord(s);
                ArrayList<String> a = new ArrayList<>();
                
                // вывод полученных строк
                for (String res : s) {
                    if ((s.length < 3) || (s.length> 5)) || () {
                        a.add(s)
                        
                }
                    
                    System.out.println(res);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                  }
                }
        } 
    }
    
    
}
