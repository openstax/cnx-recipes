"""Tests to validate JSON metadata extraction and file generation pipeline"""
import subprocess
import os
import json
from glob import glob

HERE = os.path.abspath(os.path.dirname(__file__))
TEST_DATA_DIR = os.path.join(HERE, "data")
SCRIPT_DIR = os.path.join(HERE, "../script")

def test_jsonify_book(tmp_path):
    """Test basic input / output for jsonify-book script"""
    jsonify_book_script = os.path.join(SCRIPT_DIR, "jsonify-book.py")

    html_content = "<html><body>test body</body></html>"
    json_metadata_content = {
        "title": "subsection title",
        "abstract": "subsection abstract",
        "slug": "1-3-subsection-slug"
    }

    disassembled_input_dir = tmp_path / "disassembled"
    disassembled_input_dir.mkdir()

    xhtml_input = disassembled_input_dir / "m00001@1.1.xhtml"
    xhtml_input.write_text(html_content)
    json_metadata_input = disassembled_input_dir / "m00001@1.1-metadata.json"
    json_metadata_input.write_text(json.dumps(json_metadata_content))

    jsonified_output_dir = tmp_path / "jsonified"
    jsonified_output_dir.mkdir()

    subprocess.run(
        [
            "python",
            jsonify_book_script,
            disassembled_input_dir,
            tmp_path / "jsonified"
        ],
        cwd=HERE,
        check=True
    )

    jsonified_output = jsonified_output_dir / "m00001@1.1.json"
    jsonified_output_data = json.loads(jsonified_output.read_text())

    assert jsonified_output_data.get("title") == json_metadata_content["title"]
    assert jsonified_output_data.get("abstract") == json_metadata_content["abstract"]
    assert jsonified_output_data.get("slug") == json_metadata_content["slug"]
    assert jsonified_output_data.get("content") == html_content

def test_disassemble_book(tmp_path):
    """Test basic input / output for disassemble-book script"""
    disassemble_book_script = os.path.join(SCRIPT_DIR, "disassemble-book.py")
    input_baked_xhtml = os.path.join(TEST_DATA_DIR, "collection.baked.xhtml")
    input_baked_metadata = os.path.join(TEST_DATA_DIR, "collection.baked-metadata.json")

    input_dir = tmp_path / "book"
    input_dir.mkdir()

    input_baked_xhtml_file = input_dir / "collection.baked.xhtml"
    input_baked_xhtml_file.write_bytes(open(input_baked_xhtml, "rb").read())
    input_baked_metadata_file = input_dir / "collection.baked-metadata.json"
    input_baked_metadata_file.write_text(open(input_baked_metadata, "r").read())

    disassembled_output = input_dir / "disassembled"
    disassembled_output.mkdir()

    subprocess.run(
        [
            "python",
            disassemble_book_script,
            input_dir
        ],
        cwd=HERE,
        check=True
    )

    xhtml_output_files = glob(f"{disassembled_output}/*.xhtml")
    assert len(xhtml_output_files) == 2
    json_output_files = glob(f"{disassembled_output}/*-metadata.json")
    assert len(json_output_files) == 2

    # Check for expected files and metadata that should be generated in this step
    json_output_m42119 = disassembled_output / "m42119@1.6-metadata.json"
    json_output_m42092 = disassembled_output / "m42092@1.10-metadata.json"
    m42119_data = json.load(open(json_output_m42119, "r"))
    m42092_data = json.load(open(json_output_m42092, "r"))
    assert m42119_data.get("title") == \
        "Introduction to Science and the Realm of Physics, Physical Quantities, and Units"
    assert m42119_data.get("slug") == \
        "1-introduction-to-science-and-the-realm-of-physics-physical-quantities-and-units"
    assert m42119_data.get("abstract") is None
    assert m42092_data.get("title") == "Physics: An Introduction"
    assert m42092_data.get("slug") == "1-1-physics-an-introduction"
    assert m42092_data.get("abstract") == "Explain the difference between a model and a theory"

def test_bake_book(tmp_path):
    """Test basic input / output for bake-book script"""
    bake_book_script = os.path.join(SCRIPT_DIR, "bake-book.py")
    input_baked_xhtml = os.path.join(TEST_DATA_DIR, "collection.baked.xhtml")
    input_assembled_metadata = os.path.join(
        TEST_DATA_DIR,
        "collection.assembled-metadata.json"
    )

    baked_metadata_output = tmp_path / "collection.baked-metadata.json"

    subprocess.run(
        [
            "python",
            bake_book_script,
            input_assembled_metadata,
            baked_metadata_output,
            input_baked_xhtml
        ],
        cwd=HERE,
        check=True
    )

    baked_metadata = json.loads(baked_metadata_output.read_text())
    assert baked_metadata["m42119@1.6"]["abstract"] is None
    assert baked_metadata["m42092@1.10"]["abstract"] == \
        "Explain the difference between a model and a theory"

def test_assemble_book(tmp_path):
    """Test basic input / output for assemble-book script"""
    assemble_book_script = os.path.join(SCRIPT_DIR, "assemble-book.py")
    input_assembled_xhtml = os.path.join(TEST_DATA_DIR, "collection.assembled.xhtml")

    assembled_metadata_output = tmp_path / "collection.assembed-metadata.json"

    subprocess.run(
        [
            "python",
            assemble_book_script,
            input_assembled_xhtml,
            assembled_metadata_output
        ],
        cwd=HERE,
        check=True
    )

    assembled_metadata = json.loads(assembled_metadata_output.read_text())
    assert assembled_metadata["m42119@1.6"]["abstract"] is None
    assert "Explain the difference between a model and a theory" in \
        assembled_metadata["m42092@1.10"]["abstract"]
