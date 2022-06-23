import java.io.File;
import java.util.Scanner;
import java.io.FileNotFoundException;

public class Solution {

  public static void main(String[] args) throws FileNotFoundException {
    String inputFile = System.getProperty("user.dir") + "/input.txt";
    File file = new File(inputFile);
    Scanner sc = new Scanner(file);

    int[] input = new int[200];

    for (int i = 0; i < 200; i++) {
      input[i] = Integer.parseInt(sc.nextLine());
    }

    for (int i = 0; i < 200; i++) {
      for (int j = i + 1; j < 200; j++) {
        if (input[i] + input[j] == 2020) {
          System.out.println(input[i] * input[j]);
        }
      }
    }

    for (int i = 0; i < 200; i++) {
      for (int j = i + 1; j < 200; j++) {
        for (int k = j + 1; k < 200; k++) {
          if (input[i] + input[j] + input[k] == 2020) {
            System.out.println(input[i] * input[j] * input[k]);
          }
        }
      }
    }
        
  }

}
