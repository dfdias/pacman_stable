//tex_inverter.java
import java.util.*;
import java.io.*;
public class tex_inverter{
	public static void main(String[] args)throws IOException{
		Scanner sc = new Scanner(System.in);
		char [][]a;
		char [][]inv; 
		String [] file;
		String [] file2;

		String name =new String();
		System.out.println("nome do ficheiro a inverter :");
		name = sc.nextLine();
		file = read(name);
		print(file);
		a = str2char(file);
		System.out.println("angulo a inverter :");
		int angle = sc.nextInt();
		inv=inverter(a, angle);
		file2 = char2str(inv); 
		print(file2);
	}




	public static String[] read(String name)throws IOException{
		File fin = new File(name);
		Scanner ts = new Scanner(fin);
		String[] a = new String[16];
		int i = 0;
		while(ts.hasNextLine()){
			a[i] = ts.nextLine();
			i++;	
		}
		ts.close();

		return a; 
	}

	/*public static int getSize(String name)throws IOException{
			int line = 0;
		File fin = new File(name);
		Scanner ts = new Scanner(fin);
		while(ts.hasNextLine()){
			ts.nextLine();
			line++;
		 }
		ts.close();
		return line;
	}
	*/

	public static void print(String a[]){
		for (int i = 0; i < a.length ; i++ ) {
			System.out.printf("%s\n", a[i]);
					
		}
	}

	public static char[][] str2char(String[] a){
		char[][] b = new char[16][16];
		for (int y = 0; y <= 15; y++ ) {
			for(int x = 0; x <= 15; x++ ){
				b[x][y] = a[y].charAt(x);
			}
		}
	return b;
	}

	public static char[][] inverter(char[][] a, int angle){
		char inv[][] = new char[16][16];
		if (angle == 180) {
			for (int y = 0; y <= 15 ;y++) {
				for (int x = 0;x <= 15 ;x++ ) {
					inv[x][y]=a[15-x][15-y];
				}
			}
		}
		else if(angle == 90){
			for (int y = 0; y <= 15 ;y++) {
				for (int x = 0;x <= 15;x++ ) {
					inv[y][x]=a[x][y];
				}
			}
		}
		return inv;
	}	

	public static String[] char2str(char[][] a){
		String[] b = new String[16]; 
		for (int y = 0;y <= 15; y++) {
			String c = new String();
			for (int x = 0;x <= 15;y++) {
				c = c + a[x][y];
			}
			b[y] = c;
			
		}	
		return b;
	}
	
} 


