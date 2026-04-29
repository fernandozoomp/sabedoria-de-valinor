#!/usr/bin/env python3
"""
test_subtitles.py — Testes unitários do gerador de legendas
Uso: python3 tests/test_subtitles.py
"""
import unittest
import sys
import os

# Adicionar o diretório de scripts ao path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'scripts'))

# Importar funções do generate-subtitles.py via import dinâmico
import importlib.util
spec = importlib.util.spec_from_file_location(
    "generate_subtitles", 
    os.path.join(os.path.dirname(__file__), '..', 'scripts', 'generate-subtitles.py')
)
generate_subtitles = importlib.util.module_from_spec(spec)
spec.loader.exec_module(generate_subtitles)


class TestTimestampFormatting(unittest.TestCase):
    """Testa formatação de timestamps SRT."""
    
    def test_zero_seconds(self):
        result = generate_subtitles.format_timestamp(0)
        self.assertEqual(result, "00:00:00,000")
    
    def test_seconds_only(self):
        result = generate_subtitles.format_timestamp(45.5)
        self.assertEqual(result, "00:00:45,500")
    
    def test_minutes_and_seconds(self):
        result = generate_subtitles.format_timestamp(125.75)
        self.assertEqual(result, "00:02:05,750")
    
    def test_full_timestamp(self):
        result = generate_subtitles.format_timestamp(3661.1)
        self.assertEqual(result, "01:01:01,100")
    
    def test_millisecond_precision(self):
        result = generate_subtitles.format_timestamp(0.001)
        self.assertEqual(result, "00:00:00,001")


class TestCleanText(unittest.TestCase):
    """Testa limpeza de marcas de formatação."""
    
    def test_removes_bold(self):
        result = generate_subtitles.clean_text("**texto**")
        self.assertEqual(result, "texto")
    
    def test_removes_italic(self):
        result = generate_subtitles.clean_text("*texto*")
        self.assertEqual(result, "texto")
    
    def test_removes_dramatic_pause(self):
        result = generate_subtitles.clean_text("antes [PAUSA DRAMÁTICA] depois")
        self.assertEqual(result, "antes depois")
    
    def test_normalizes_whitespace(self):
        result = generate_subtitles.clean_text("muito    espaço    aqui")
        self.assertEqual(result, "muito espaço aqui")
    
    def test_complex_text(self):
        text = "Imagine se os **guardiões**... *antigos* — e misteriosos [PAUSA DRAMÁTICA] existissem"
        result = generate_subtitles.clean_text(text)
        self.assertEqual(result, "Imagine se os guardiões... antigos — e misteriosos existissem")


class TestHighlightElvishWords(unittest.TestCase):
    """Testa destaque de termos especiais."""
    
    def test_known_name(self):
        result = generate_subtitles.highlight_elvish_words("Valinor")
        self.assertIn("#C9A84C", result)
    
    def test_known_character(self):
        result = generate_subtitles.highlight_elvish_words("Gandalf")
        self.assertIn("#C9A84C", result)
    
    def test_normal_word(self):
        result = generate_subtitles.highlight_elvish_words("guerra")
        self.assertNotIn("#C9A84C", result)
        self.assertEqual(result, "guerra")
    
    def test_name_with_punctuation(self):
        result = generate_subtitles.highlight_elvish_words("Sauron,")
        self.assertIn("#C9A84C", result)
    
    def test_middle_earth(self):
        result = generate_subtitles.highlight_elvish_words("Mordor")
        self.assertIn("#C9A84C", result)


class TestSubtitleGeneration(unittest.TestCase):
    """Testa geração de legendas karaoke e frase-por-frase."""
    
    def setUp(self):
        self.temp_dir = os.path.join(os.path.dirname(__file__), '_test_output')
        os.makedirs(self.temp_dir, exist_ok=True)
    
    def tearDown(self):
        import shutil
        if os.path.exists(self.temp_dir):
            shutil.rmtree(self.temp_dir)
    
    def test_karaoke_srt_format(self):
        """Verifica se SRT karaoke tem formato correto."""
        segments = [
            {"start": 0.0, "end": 1.5, "text": "Imagine"},
            {"start": 1.5, "end": 3.0, "text": "se os guardiões"},
        ]
        output = os.path.join(self.temp_dir, "karaoke.srt")
        generate_subtitles.generate_karaoke_srt(segments, output)
        
        with open(output, 'r', encoding='utf-8') as f:
            content = f.read()
        
        self.assertIn("1\n", content)
        self.assertIn("-->", content)
        self.assertIn("Imagine", content)
        self.assertIn("guardiões", content)
    
    def test_phrase_srt_format(self):
        """Verifica se SRT frase-por-frase funciona."""
        segments = [
            {"start": 0.0, "end": 2.0, "text": "Primeira frase."},
            {"start": 2.0, "end": 4.0, "text": "Segunda frase."},
        ]
        output = os.path.join(self.temp_dir, "phrase.srt")
        generate_subtitles.generate_phrase_srt(segments, output)
        
        with open(output, 'r', encoding='utf-8') as f:
            content = f.read()
        
        self.assertIn("Primeira frase.", content)
        self.assertIn("Segunda frase.", content)
    
    def test_empty_segments(self):
        """Verifica que segmentos vazios não quebram."""
        segments = []
        output = os.path.join(self.temp_dir, "empty.srt")
        generate_subtitles.generate_karaoke_srt(segments, output)
        
        with open(output, 'r', encoding='utf-8') as f:
            content = f.read()
        
        self.assertEqual(content.strip(), "")


if __name__ == "__main__":
    unittest.main(verbosity=2)
