unit sql;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, Db, DBTables, ExtCtrls;

type
  TForm1 = class(TForm)
    Query1: TQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Button1: TButton;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Bevel1: TBevel;
    Button2: TButton;
    RadioGroup1: TRadioGroup;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Button3: TButton;
    Button4: TButton;
    Button6: TButton;
    Button7: TButton;
    Bevel3: TBevel;
    Bevel2: TBevel;
    Button5: TButton;
    Edit2: TEdit;
    Edit3: TEdit;
    Button10: TButton;
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Query1BeforeOpen(DataSet: TDataSet);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox2KeyPress(Sender: TObject; var Key: Char);
    procedure Button5Click(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3Change(Sender: TObject);
    procedure Button10Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
 Application.Title:='База данных лекций текущего семестра';
 DataSource1.DataSet:=Query1;
 DBGrid1.DataSource:=DataSource1;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 i: integer;
begin
 Query1.Close;
 Query1.SQL.Clear;
 Query1.SQL.Add('Select '+ComboBox1.Text+
       ' from kurs_predm.db '+'Order by '+ComboBox2.Text);
 Query1.Open;
 // rus names
 try
  if ComboBox1.Text='*' then
   begin
    Query1.FieldByName('NameDis').DisplayLabel:='Наименование дисциплины';
    Query1.FieldByName('Prepod').DisplayLabel:='Преподаватель';
    Query1.FieldByName('WeekDay').DisplayLabel:='День недели';
    Query1.FieldByName('DisTime').DisplayLabel:='Время';
   end
  else
   begin
    for i:=0 to ComboBox1.Items.Count-1 do
     if ComboBox2.Text=ComboBox1.Items.Strings[i]
     then Query1.FieldByName(ComboBox2.Text).DisplayLabel:=ListBox1.Items.Strings[i-1];
   end;
 except
 end;
 // списки полей
 ComboBox1.Items.Clear;
 ComboBox1.Items.Add('*');
 for i:=0 to Query1.FieldCount-1 do
  ComboBox1.Items.Add(Query1.Fields.Fields[i].FieldName);
 ComboBox2.Items.Clear;
 for i:=0 to Query1.FieldCount-1 do
  ComboBox2.Items.Add(Query1.Fields.Fields[i].FieldName);
 //
 ComboBox1.Enabled:=true;
 ComboBox2.Enabled:=true;
 CheckBox2.Enabled:=true; 
 Button2.Enabled:=true;
 Button3.Enabled:=true;
 Button4.Enabled:=true;
 Button5.Enabled:=true;
 Button6.Enabled:=true;
 Button7.Enabled:=true;
 Button10.Enabled:=true; 
end;

procedure TForm1.Query1BeforeOpen(DataSet: TDataSet);
begin
 if CheckBox1.Checked then Abort;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
 n:integer;
begin
 // отключение отображения записей в визуальных компонентах
 Query1.DisableControls;
 Query1.First;
 for n:=1 to Query1.RecordCount do
  begin
   // обработка записи набора данных Table1
   Query1.Next;
  end;
 // включение отображения записей в визуальных компонентах
 Query1.EnableControls;
end;

procedure TForm1.Edit1Change(Sender: TObject);
var
 strField:string;
begin
 if not CheckBox2.Checked then Exit;
 // выбрать поле поиска
 case RadioGroup1.ItemIndex of
  0: strField:='NameDis';
  1: strField:='Prepod';
  2: strField:='WeekDay';
 end;
 // выполнить поиск
 Query1.Locate(strField,Edit1.Text,[loCaseInsensitive,loPartialKey]);
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
 if CheckBox2.Checked=true
 then
  begin
   CheckBox2.Caption:='Режим поиска включен';
   Edit3.SetFocus;
  end
 else CheckBox2.Caption:='Режим поиска выключен';
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 Query1.First;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 Query1.Last;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
 Query1.Insert;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
 Query1.Delete;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
 if ComboBox1.Text<>'*'
 then
  begin
   ComboBox2.Enabled:=false;
   ComboBox2.Text:=ComboBox1.Text;
  end
 else ComboBox2.Enabled:=true;
end;

procedure TForm1.ComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13 then
  begin
   Key:=#0;
   Button1.Click;
  end;
end;

procedure TForm1.ComboBox2KeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13 then
  begin
   Key:=#0;
   Button1.Click;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
 Query1.Close;
 Query1.SQL.Clear;
 Query1.SQL.Add('Select * from kurs_predm.db where Prepod LIKE "%" || "'+Edit2.Text+'" || "%"');
 Query1.Open;
 Query1.FieldByName('NameDis').DisplayLabel:='Наименование дисциплины';
 Query1.FieldByName('Prepod').DisplayLabel:='Преподаватель';
 Query1.FieldByName('WeekDay').DisplayLabel:='День недели';
 Query1.FieldByName('DisTime').DisplayLabel:='Время';
end;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13 then
  begin
   Key:=#0;
   Button5.Click;
  end;
end;

procedure TForm1.Edit3Change(Sender: TObject);
var
 strField:string;
begin
 if not CheckBox2.Checked then Exit;
 // выбрать поле поиска
 case RadioGroup1.ItemIndex of
  0: strField:='NameDis';
  1: strField:='Prepod';
  2: strField:='WeekDay';
 end;
 // выполнить поиск
 Query1.Close;                              // |
 Query1.SQL.Clear;                 //  ' LIKE "%'+Edit3.Text+'%"' - ищет фрагмент текста
 Query1.SQL.Add('Select * from kurs_predm.db where '+strField+' LIKE "'+Edit3.Text+'%"');
 Query1.Open;
 Query1.FieldByName('NameDis').DisplayLabel:='Наименование дисциплины';
 Query1.FieldByName('Prepod').DisplayLabel:='Преподаватель';
 Query1.FieldByName('WeekDay').DisplayLabel:='День недели';
 Query1.FieldByName('DisTime').DisplayLabel:='Время';
end;

procedure TForm1.Button10Click(Sender: TObject);
var
 i: integer;
begin
 Query1.Close;
 Query1.SQL.Clear;
 Query1.SQL.Add('Select * from kurs_predm.db Order by NameDis');
 Query1.Open;
 // rus names
 try
  Query1.FieldByName('NameDis').DisplayLabel:='Наименование дисциплины';
  Query1.FieldByName('Prepod').DisplayLabel:='Преподаватель';
  Query1.FieldByName('WeekDay').DisplayLabel:='День недели';
  Query1.FieldByName('DisTime').DisplayLabel:='Время';
 except
 end;
 // списки полей
 ComboBox1.Items.Clear;
 ComboBox1.Text:='*';
 ComboBox1.Items.Add('*');
 for i:=0 to Query1.FieldCount-1 do
  ComboBox1.Items.Add(Query1.Fields.Fields[i].FieldName);
 ComboBox2.Items.Clear;
 ComboBox2.Text:='NameDis';
 for i:=0 to Query1.FieldCount-1 do
  ComboBox2.Items.Add(Query1.Fields.Fields[i].FieldName);
 Edit1.Text:='';
 Edit3.Text:='';
end;

end.