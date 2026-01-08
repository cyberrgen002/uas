program ModernMenuApp;

uses crt, SysUtils; // Line 3

const
  MenuCount = 6;
  MaxData = 100;
  COLOR_HEADER_BG = Blue;
  COLOR_HEADER_FG = White;
  COLOR_MENU_BG = Black;
  COLOR_MENU_FG = LightGray;
  COLOR_SELECTED_BG = LightBlue; // Warna yang lebih menarik untuk highlight
  COLOR_SELECTED_FG = White;
  COLOR_PROMPT_FG = Yellow;
  COLOR_INFO_FG = Green;
  CONSOLE_WIDTH = 80; // Lebar konsol standar
  MathMenuCount = 4;

type
  TDataList = array[1..MaxData] of string;

var
  Menu: array[1..MenuCount] of string = (
    'Lihat Data',
    'Tambah Data',
    'Hapus Data',
    'Edit Data',
    'Operasi Matematika',
    'Keluar'
  );
  MathMenu: array[1..MathMenuCount] of string = (
    'Penjumlahan',
    'Pengurangan',
    'Perkalian',
    'Pembagian'
  );
  CurrentSelection: integer;
  Key: char;
  ExitProgram: boolean;
  DataList: TDataList;
  DataCount: integer;

// Fungsi utilitas untuk memposisikan teks di tengah
procedure CenterText(const S: string);
var
  Padding: integer;
begin
  Padding := (CONSOLE_WIDTH - Length(S)) div 2;
  GotoXY(Padding + 1, WhereY);
  Write(S);
end;

procedure ShowHeader;
var
  i: integer;
  HeaderTitle: string;
begin
  HeaderTitle := ' PROGRAM MANAJEMEN DATA SEDERHANA ';
  
  // Baris Atas
  TextBackground(COLOR_HEADER_BG);
  TextColor(COLOR_HEADER_FG);
  ClrScr;
  for i := 1 to CONSOLE_WIDTH do Write(' '); // Isi baris pertama dengan warna latar
  
  // Baris Judul
  GotoXY(1, 2);
  CenterText(HeaderTitle);
  
  // Baris Bawah
  GotoXY(1, 3);
  for i := 1 to CONSOLE_WIDTH do Write(' ');
  
  // Atur warna kembali ke standar menu
  TextBackground(COLOR_MENU_BG);
  TextColor(COLOR_MENU_FG);
  
  // Pindah kursor ke bawah header
  GotoXY(1, 5);
end;


procedure ShowMenu;
var
  i: integer;
  MenuLine: string;
begin
  ShowHeader;
  
  // Garis pemisah visual
  TextColor(DarkGray);
  Writeln('=':CONSOLE_WIDTH); 
  TextColor(COLOR_MENU_FG);
  
  Writeln;
  
  for i := 1 to MenuCount do
  begin
    MenuLine := '  ' + IntToStr(i) + '. ' + Menu[i];
    
    if i = CurrentSelection then
    begin
      TextBackground(COLOR_SELECTED_BG);
      TextColor(COLOR_SELECTED_FG);
      CenterText(MenuLine);
      WriteLn;
      TextBackground(COLOR_MENU_BG);
      TextColor(COLOR_MENU_FG);
    end
    else
    begin
      CenterText(MenuLine);
      WriteLn;
    end;
  end;
  
  Writeln;
  
  // Instruksi navigasi
  TextColor(COLOR_PROMPT_FG);
  GotoXY(1, WhereY);
  CenterText('Gunakan panah [^]/[v] untuk navigasi, [Enter] untuk memilih');
  TextColor(COLOR_MENU_FG);
end;

// Prosedur data diubah untuk menggunakan CenterText dan warna info
procedure LihatData;
var
  i: integer;
begin
  ShowHeader;
  CenterText('=== 📜 LIHAT DATA ===');
  Writeln;
  Writeln;
  
  if DataCount = 0 then
  begin
    TextColor(Red);
    CenterText('Data kosong.');
    TextColor(COLOR_MENU_FG);
  end
  else
  begin
    TextColor(LightGreen);
    for i := 1 to DataCount do
    begin
      CenterText(Format('%d. %s', [i, DataList[i]])); // Menggunakan Format (jika didukung) atau string manual
      Writeln;
    end;
    TextColor(COLOR_MENU_FG);
  end;
  
  Writeln;
  Writeln;
  TextColor(COLOR_PROMPT_FG);
  CenterText('Tekan [Enter] untuk kembali ke menu...');
  TextColor(COLOR_MENU_FG);
  readln;
end;

procedure TambahData;
var
  Input: string;
begin
  ShowHeader;
  CenterText('=== ✨ TAMBAH DATA ===');
  Writeln;
  Writeln;
  
  if DataCount >= MaxData then
  begin
    TextColor(Red);
    CenterText('Data penuh, tidak bisa menambah.');
    TextColor(COLOR_MENU_FG);
    readln;
    exit;
  end;
  
  TextColor(COLOR_PROMPT_FG);
  Write('  Masukkan data baru (max 255 char): ');
  readln(Input);
  
  Inc(DataCount);
  DataList[DataCount] := Input;
  
  Writeln;
  TextColor(COLOR_INFO_FG);
  CenterText('✅ Data berhasil ditambahkan!');
  TextColor(COLOR_MENU_FG);
  
  Writeln;
  TextColor(COLOR_PROMPT_FG);
  CenterText('Tekan [Enter] untuk kembali ke menu...');
  TextColor(COLOR_MENU_FG);
  readln;
end;

procedure HapusData;
var
  Index, i: integer;
begin
  ShowHeader;
  CenterText('=== 🗑️ HAPUS DATA ===');
  Writeln;
  Writeln;

  if DataCount = 0 then
  begin
    TextColor(Red);
    CenterText('Data kosong, tidak ada yang bisa dihapus.');
    TextColor(COLOR_MENU_FG);
    readln;
    exit;
  end;

  TextColor(COLOR_PROMPT_FG);
  Write('  Masukkan nomor data yang ingin dihapus: ');
  readln(Index);
  
  if (Index < 1) or (Index > DataCount) then
  begin
    TextColor(Red);
    CenterText('Nomor salah atau tidak ditemukan.');
    TextColor(COLOR_MENU_FG);
    readln;
    exit;
  end;

  for i := Index to DataCount - 1 do
    DataList[i] := DataList[i + 1];
  Dec(DataCount);
  
  Writeln;
  TextColor(COLOR_INFO_FG);
  CenterText('✅ Data berhasil dihapus!');
  TextColor(COLOR_MENU_FG);
  
  Writeln;
  TextColor(COLOR_PROMPT_FG);
  CenterText('Tekan [Enter] untuk kembali ke menu...');
  TextColor(COLOR_MENU_FG);
  readln;
end;

procedure EditData;
var
  Index: integer;
  Input: string;
begin
  ShowHeader;
  CenterText('=== ✏️ EDIT DATA ===');
  Writeln;
  Writeln;
  
  if DataCount = 0 then
  begin
    TextColor(Red);
    CenterText('Data kosong, tidak ada yang bisa diedit.');
    TextColor(COLOR_MENU_FG);
    readln;
    exit;
  end;

  TextColor(COLOR_PROMPT_FG);
  Write('  Masukkan nomor data yang ingin diedit: ');
  readln(Index);
  
  if (Index < 1) or (Index > DataCount) then
  begin
    TextColor(Red);
    CenterText('Nomor salah atau tidak ditemukan.');
    TextColor(COLOR_MENU_FG);
    readln;
    exit;
  end;
  
  Writeln;
  Write('  Data saat ini: ');
  TextColor(LightCyan);
  Writeln(DataList[Index]);
  TextColor(COLOR_PROMPT_FG);
  
  Write('  Masukkan data baru: ');
  readln(Input);
  
  DataList[Index] := Input;
  
  Writeln;
  TextColor(COLOR_INFO_FG);
  CenterText('✅ Data berhasil diubah!');
  TextColor(COLOR_MENU_FG);
  
  Writeln;
  TextColor(COLOR_PROMPT_FG);
  CenterText('Tekan [Enter] untuk kembali ke menu...');
  TextColor(COLOR_MENU_FG);
  readln;
end;

procedure Penjumlahan;
var
  Num1, Num2, Hasil: Real;
  Input1, Input2: string;
begin
  ShowHeader;
  CenterText('=== ➕ PENJUMLAHAN ===');
  Writeln;
  Writeln;
  
  TextColor(COLOR_PROMPT_FG);
  Write('  Masukkan angka pertama: ');
  readln(Input1);
  Write('  Masukkan angka kedua: ');
  readln(Input2);
  
  Num1 := StrToFloat(Input1);
  Num2 := StrToFloat(Input2);
  Hasil := Num1 + Num2;
  
  Writeln;
  TextColor(COLOR_INFO_FG);
  CenterText(Format('%.2f + %.2f = %.2f', [Num1, Num2, Hasil]));
  TextColor(COLOR_MENU_FG);
  
  Writeln;
  TextColor(COLOR_PROMPT_FG);
  CenterText('Tekan [Enter] untuk kembali ke menu...');
  TextColor(COLOR_MENU_FG);
  readln;
end;

procedure Pengurangan;
var
  Num1, Num2, Hasil: Real;
  Input1, Input2: string;
begin
  ShowHeader;
  CenterText('=== ➖ PENGURANGAN ===');
  Writeln;
  Writeln;
  
  TextColor(COLOR_PROMPT_FG);
  Write('  Masukkan angka pertama: ');
  readln(Input1);
  Write('  Masukkan angka kedua: ');
  readln(Input2);
  
  Num1 := StrToFloat(Input1);
  Num2 := StrToFloat(Input2);
  Hasil := Num1 - Num2;
  
  Writeln;
  TextColor(COLOR_INFO_FG);
  CenterText(Format('%.2f - %.2f = %.2f', [Num1, Num2, Hasil]));
  TextColor(COLOR_MENU_FG);
  
  Writeln;
  TextColor(COLOR_PROMPT_FG);
  CenterText('Tekan [Enter] untuk kembali ke menu...');
  TextColor(COLOR_MENU_FG);
  readln;
end;

procedure Perkalian;
var
  Num1, Num2, Hasil: Real;
  Input1, Input2: string;
begin
  ShowHeader;
  CenterText('=== ✖️ PERKALIAN ===');
  Writeln;
  Writeln;
  
  TextColor(COLOR_PROMPT_FG);
  Write('  Masukkan angka pertama: ');
  readln(Input1);
  Write('  Masukkan angka kedua: ');
  readln(Input2);
  
  Num1 := StrToFloat(Input1);
  Num2 := StrToFloat(Input2);
  Hasil := Num1 * Num2;
  
  Writeln;
  TextColor(COLOR_INFO_FG);
  CenterText(Format('%.2f * %.2f = %.2f', [Num1, Num2, Hasil]));
  TextColor(COLOR_MENU_FG);
  
  Writeln;
  TextColor(COLOR_PROMPT_FG);
  CenterText('Tekan [Enter] untuk kembali ke menu...');
  TextColor(COLOR_MENU_FG);
  readln;
end;

procedure Pembagian;
var
  Num1, Num2, Hasil: Real;
  Input1, Input2: string;
begin
  ShowHeader;
  CenterText('=== ➗ PEMBAGIAN ===');
  Writeln;
  Writeln;
  
  TextColor(COLOR_PROMPT_FG);
  Write('  Masukkan angka pertama: ');
  readln(Input1);
  Write('  Masukkan angka kedua: ');
  readln(Input2);
  
  Num1 := StrToFloat(Input1);
  Num2 := StrToFloat(Input2);
  
  if Num2 = 0 then
  begin
    Writeln;
    TextColor(Red);
    CenterText('❌ Kesalahan: Tidak bisa membagi dengan nol!');
    TextColor(COLOR_MENU_FG);
  end
  else
  begin
    Hasil := Num1 / Num2;
    Writeln;
    TextColor(COLOR_INFO_FG);
    CenterText(Format('%.2f / %.2f = %.2f', [Num1, Num2, Hasil]));
    TextColor(COLOR_MENU_FG);
  end;
  
  Writeln;
  TextColor(COLOR_PROMPT_FG);
  CenterText('Tekan [Enter] untuk kembali ke menu...');
  TextColor(COLOR_MENU_FG);
  readln;
end;

procedure OperasiMatematika;
var
  CurrentMathSelection: integer;
  MathKey: char;
  ExitMath: boolean;
  i: integer;
  MenuLine: string;
begin
  CurrentMathSelection := 1;
  ExitMath := False;
  
  repeat
    ShowHeader;
    CenterText('=== 🔢 OPERASI MATEMATIKA ===');
    Writeln;
    Writeln;
    
    for i := 1 to MathMenuCount do
    begin
      MenuLine := '  ' + IntToStr(i) + '. ' + MathMenu[i];
      
      if i = CurrentMathSelection then
      begin
        TextBackground(COLOR_SELECTED_BG);
        TextColor(COLOR_SELECTED_FG);
        CenterText(MenuLine);
        WriteLn;
        TextBackground(COLOR_MENU_BG);
        TextColor(COLOR_MENU_FG);
      end
      else
      begin
        CenterText(MenuLine);
        WriteLn;
      end;
    end;
    
    Writeln;
    TextColor(COLOR_PROMPT_FG);
    CenterText('Gunakan panah [^]/[v] untuk navigasi, [Enter] untuk memilih, [Esc] kembali');
    TextColor(COLOR_MENU_FG);
    
    MathKey := ReadKey;
    
    if MathKey = #0 then
    begin
      MathKey := ReadKey;
      case MathKey of
        #72: if CurrentMathSelection > 1 then Dec(CurrentMathSelection); // Panah atas
        #80: if CurrentMathSelection < MathMenuCount then Inc(CurrentMathSelection); // Panah bawah
      end;
    end
    else if MathKey = #13 then // Enter
    begin
      case CurrentMathSelection of
        1: Penjumlahan;
        2: Pengurangan;
        3: Perkalian;
        4: Pembagian;
      end;
    end
    else if MathKey = #27 then // Esc
      ExitMath := True;
    
  until ExitMath;
end;

begin
  // Inisialisasi awal
  CurrentSelection := 1;
  ExitProgram := False;
  DataCount := 0;
  
  // Atur jendela konsol (Opsional, tergantung OS dan compiler)
  // window(1, 1, 80, 25);
  // textmode(CO80);

  repeat
    ShowMenu;
    Key := ReadKey;

    if Key = #0 then
    begin
      Key := ReadKey;
      case Key of
        #72: if CurrentSelection > 1 then Dec(CurrentSelection); // Panah atas
        #80: if CurrentSelection < MenuCount then Inc(CurrentSelection); // Panah bawah
      end;
    end
    else if Key = #13 then // Tombol Enter
    begin
      case CurrentSelection of
        1: LihatData;
        2: TambahData;
        3: HapusData;
        4: EditData;
        5: OperasiMatematika;
        6: ExitProgram := True;
      end;
    end;

  until ExitProgram;

  // Layar keluar
  ClrScr;
  TextBackground(Black);
  TextColor(White);
  Writeln;
  CenterText('🎉 Terima kasih telah menggunakan PROGRAM MANAJEMEN DATA SEDERHANA!');
  Writeln;
  Readln; 
end.
