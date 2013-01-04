/* 
* 入力元の画像を明度で二値化し、
* 波形モニターにその形の図形が現れるように画像を計算し出力。
*/

int     imgWidth   = 1280;    // イメージの幅
int     depth      = 255;     // 階調の数
int     fps        = 4;       // 処理速度
int     count      = 290;     // フレーム数
int     digit      = 3;       // ファイル名の連番の桁数
String  srcPrefix  = "src_";  // ソースファイルの接頭語
String  srcExt     = ".png";  // ソースファイルの接尾語(拡張子)
String  outPrefix  = "out_";  // 出力ファイル名の接頭語
String  outExt     = ".png";  // 出力ファイル名の接尾語(拡張子)

void setup() {
  size(imgWidth, depth);
  frameRate(fps);
  colorMode(HSB, depth);
}

void draw() {
  if (frameCount >= count) {
    exit();
  }
  
  // load
  int frameNumber = frameCount - 1;
  String resName = srcPrefix 
                 + String.format("%0" + digit + "d", frameNumber)
                 + srcExt;
  println(resName);
  PImage img = loadImage(resName);
  image(img, 0, 0, imgWidth, depth);
  
  loadPixels();
  
  for (int i = 0; i < imgWidth; i++) {
    
    int[] samp = new int[depth];
    int count = 0; 
    
    // sampling brightness
    for (int j = 0; j < depth; j++) {
      color c = get(i, j);
      if (brightness(c) >= depth / 2) { // 明度を２値化,白かったら描画
        samp[count++] = depth - j;
      }
    }
    
    // draw
    if(count == 0) {  // 何もピクセルが存在しなかった場合
      count = 1;
      samp[0] = 0;
    }
    
    int mod = depth % count;
    int band = depth / count;
    
    for(int j = 0; j < mod; j++) {
      pixels[i + j * imgWidth] = color(samp[0]);
    }
    
    for (int j = 0; j < count; j++) {
      for (int k = 0; k < band; k++) {
        pixels[i + (mod + j * band + k) * imgWidth] = color(samp[j]);
      }
    }  
  }
  
  updatePixels();
  
  // save current frame
  String outName = outPrefix;
  for (int i = 0; i < digit; i++) {
    outName += "#";
  }
  outName += outExt;
  saveFrame(outName);  
}
