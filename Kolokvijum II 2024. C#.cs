using System;
using System.Data;
using Oracle.DataAccess.Client;

namespace Zadatak
{
    class Program
    {
        static void Main(string[] args)
        {
            // 1. Definišemo konekcioni string
            string conString = "Data Source=160.99.9.63/GISLAB.ni.ac.rs;User Id=11111;Password=11111;";
            OracleConnection con = null;

            try
            {
                // 2. Pravimo novu konekciju
                con = new OracleConnection(conString);
                con.Open();

                // 3. Unos ID kompanije
                Console.WriteLine("Unesite jedinstveni identifikator kompanije:");
                int idKompanije = int.Parse(Console.ReadLine());

                // 4. SQL upit
                string strSQL = @"
                    SELECT ZAPOSLENI.IME, ZAPOSLENI.PREZIME
                    FROM ZAPOSLENI
                    INNER JOIN RADNO_MESTO ON ZAPOSLENI.JMBG = RADNO_MESTO.ZJMBG
                    WHERE RADNO_MESTO.IDK = :idKompanije AND RADNO_MESTO.POZICIJA = 'PRODAVAC' AND RADNO_MESTO.DATUMDO IS NULL";

                // 5. Priprema DataAdapter-a
                OracleDataAdapter da = new OracleDataAdapter(strSQL, con);
                da.SelectCommand.Parameters.Add(new OracleParameter("idKompanije", idKompanije));

                // 6. Kreiranje i popunjavanje DataSet-a
                DataSet ds = new DataSet();
                da.Fill(ds, "ZAPOSLENI");

                // 7. Ispis rezultata
                Console.WriteLine("Zaposleni koji trenutno rade na poziciji prodavca u kompaniji:");
                foreach (DataRow r in ds.Tables["ZAPOSLENI"].Rows)
                {
                    string ime = (string)r["IME"];
                    string prezime = (string)r["PREZIME"];
                    Console.WriteLine($"Ime: {ime}, Prezime: {prezime}");
                }
            }
            catch (Exception ex)
            {
                // 8. Obrada greške
                Console.WriteLine("Došlo je do greške prilikom pristupa bazi podataka: " + ex.Message);
            }
            finally
            {
                // 9. Zatvaranje konekcije
                if (con != null && con.State == ConnectionState.Open)
                {
                    con.Close();
                }
                con = null;
            }
        }
    }
}
